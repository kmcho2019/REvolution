```thought
To implement the gshare branch predictor, we need to design a module with two main components: a global branch history register and a pattern history table (PHT). The global branch history register is used to keep track of the recent branch outcomes, and the PHT is a table of saturating counters that store the prediction history for each possible branch.

The module will have two sets of interfaces: one for making predictions and one for training the predictor. When a prediction is requested, the module will use the current global branch history and the pc to index into the PHT and retrieve the corresponding prediction. The global branch history will then be updated based on the predicted branch direction.

When training is requested, the module will use the provided pc, branch history, and actual branch outcome to update the corresponding entry in the PHT. If the branch was mispredicted, the global branch history will be recovered to its state before the misprediction.

To handle the case where training and prediction occur in the same cycle, we will prioritize training over prediction. This means that if a training request is made for

--- WARNING: Parsing Issues ---
Could not parse 'thought' from LLM response. Expected ```thought ... ``` block.(PARSE_ERROR)
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
