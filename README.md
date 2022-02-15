# Galaxy Example ARC
This example ARC was generated using This was generated using https://github.com/nfdi4plants/galaxy-workflow-to-arc and showcases the CWL and Galaxy integration using [Planemo](https://planemo.readthedocs.io/en/latest/).


In order to run this ARC, first make sure that you have [Docker](https://www.docker.com/) and [Cwltool](https://github.com/common-workflow-language/cwltool) installed on your system. After that, execute the following steps:

1. Create an account and login on https://usegalaxy.eu/
2. Go to https://usegalaxy.eu/user/api_key to obtain your API key
3. Clone this repository and navigate to the directory on your commandline
4. Execute the following command (make sure to insert your API key from step 2): 

```
ARC_GALAXY_URL="https://usegalaxy.eu" ARC_GALAXY_API_KEY="<YOUR_API_KEY_FROM_STEP_2>" cwltool --preserve-environment ARC_GALAXY_URL --preserve-environment ARC_GALAXY_API_KEY --outdir runs/run1 runs/run1/run.cwl runs/run1/run.yml 
```

Hint: The results will be placed in the runs/run1/history folder. If you want to try out a clean run, delete this folder first.
