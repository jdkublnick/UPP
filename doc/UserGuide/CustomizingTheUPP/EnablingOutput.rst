.. _enabling-output:

********************************
User-Defined Sigma Level Output
********************************

This documentation describes the steps to generate model output at user-defined sigma levels using the Unified Post Processor (UPP). The instructions address the configuration of XML files and the resolution of potential issues encountered during this process.

Generating Sigma Level Output
-----------------------------

UPP can output temperature, U, and V components on sigma surfaces. These correspond to indices 206, 208, and 209 in the :term:`GRIB2`` table. Follow these steps to configure your workflow for this output:

**Configuring XML Files**

1. **Locate XML Configuration Files**:
   - Use the XML files in the `UPP/parm` directory as references. Specifically, the `post_avblflds.xml` file contains all the fields that UPP can output.

2. **Modify Control XML**:
   - Copy the entries for temperature, U, and V (indices 206, 208, and 209) from `post_avblflds.xml` to the control XML file used in your workflow.

3. **Validation**:
   - Validate the control XML file against the `EMC_POST_CTRL_Schema.xsd` schema.

4. **Flat Text File Generation**:
   - Convert the control XML to a flat text file, ensuring that it is validated as part of the process. More information can be found in the :ref:`create_txt_file` documentation.

**Sigma Levels**

By default, only certain sigma levels are outputted. These levels are defined in `SET_LVLSXML.f <https://github.com/NOAA-EMC/UPP/blob/develop/sorc/ncep_post.fd/SET_LVLSXML.f>`_ using the ``ASIGO1`` array. Users must review these levels in the ``SET_LVLSXML.f`` file to confirm compatibility with their requirements.


Required Source Code Modifications
----------------------------------

If the default sigma levels are insufficient, you must:

1. **Modify `SET_LVLSXML.f`**:
   - Change the entries for `ASIGO1` to include your desired sigma levels.

2. **Recompile UPP**:
   - Recompile the UPP source code after making the changes.

3. **Update XML Tags**:
   - Ensure that the XML tags explicitly reference the modified sigma levels.

Important Notes
---------------

- Adding `<level></level>` tags manually allows UPP to compile and run successfully, but it will not produce any output unless the levels are also modified in `SET_LVLSXML.f` and properly referenced.

- Fortran I/O errors may occur if the sigma levels in the control file are not synchronized with the source code configuration.

- Comprehensive documentation on control files can be found in the :ref:`control-file` documentation, which provides details about XML file formatting and flat file generation.

By following these steps, users can successfully configure UPP to generate model output on user-defined sigma levels while avoiding common pitfalls.
