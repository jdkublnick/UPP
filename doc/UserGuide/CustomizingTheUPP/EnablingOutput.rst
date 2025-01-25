.. role:: bolditalic
    :class: bolditalic

.. _enabling-output:

********************************
User-Defined Sigma Level Output
********************************

This documentation describes the steps to generate model output at user-defined sigma levels using the Unified Post Processor (UPP). The instructions address the configuration of XML files and the resolution of potential issues encountered during this process.

Generating Sigma Level Output
-----------------------------

UPP can output temperature, U, and V components on sigma surfaces. These correspond to indices 206, 208, and 209 in the :doc:`GRIB2 <UPP_GRIB2_Table_byID>` table. Follow these steps to configure your workflow for this output:

Configuring XML Files
^^^^^^^^^^^^^^^^^^^^^^

An XML :ref:`control file <control-file>` determines what fields and levels UPP will output. 

#. **Locate the XML Control File**: Control files for various operational models are located in the ``UPP/parm`` directory. The ``post_avblflds.xml`` file contains all fields that the UPP can output. 

#. **Modify the Control XML**: Copy the entries for temperature, U, and V (indices 206, 208, and 209) from ``post_avblflds.xml`` to the control XML file used in your workflow. Be sure to include a ``<level></level>`` tag with the appropriate levels in the XML control file to define which sigma levels to output.

#. **Validate the Control File**: Validate the control XML file against the ``EMC_POST_CTRL_Schema.xsd`` schema according to :ref:`these instructions <create_txt_file>`.

#. **Flat Text File Generation**: Convert the control XML to a flat text file based on the information in the :ref:`create_txt_file` documentation.

Source Code Modifications
^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, only certain sigma levels are outputted. These levels are defined in `SET_LVLSXML.f <https://github.com/NOAA-EMC/UPP/blob/develop/sorc/ncep_post.fd/SET_LVLSXML.f>`_ using the ``ASIGO1`` array. Users must review these levels in the ``SET_LVLSXML.f`` file to confirm compatibility with their requirements. If the default sigma levels are insufficient, users must:

#. **Modify** :bolditalic:`SET_LVLSXML.f`: Change the entries for ``ASIGO1`` to include your desired sigma levels.

#. **Recompile UPP**: Recompile the UPP source code after making the changes.

#. **Update XML Tags**: Ensure that the XML control file explicitly references the modified sigma levels in the ``<level></level>`` tag.

.. hint::

   - Adding ``<level></level>`` tags manually allows UPP to compile and run successfully, but it will not produce any output unless the levels are also modified in ``SET_LVLSXML.f`` and properly referenced.

   - Fortran I/O errors may occur if the sigma levels in the control file are not synchronized with the source code configuration.

   - Comprehensive documentation on control files can be found in the :ref:`control-file` documentation, which provides details about XML file formatting and flat file generation.
