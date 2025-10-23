```thought
To implement the gshare branch predictor as described, we need to consider several key components and their interactions:
1. **Global Branch History Register (GBHR):** A 7-bit register that keeps track of the branch history. The history is updated based on the predicted outcome of branches.
2. **Pattern History Table (PHT):** A 128-entry table of two-bit saturating counters. Each entry in the PHT is indexed by hashing the current PC and GBHR. 
3. **Prediction Logic:** When a prediction is requested (predict_valid = 1), the predictor calculates the index into the PHT using the PC and the current GBHR, and then uses the counter value at this index to predict the branch direction.
4. **Training Logic:** When training is requested (train_valid = 1), the predictor updates the PHT entry corresponding to the train_history and train_pc. If the branch was mispredicted, the GBHR is also updated to its state immediately after the mispredicting branch completes execution.
5. **Update and Recovery Logic:** Managing how and when the GBHR and PHT are updated, ensuring that training takes precedence over predictions in the same cycle, and handling cases where a prediction and training for the same PHT entry occur simultaneously.

The predictor must also handle asynchronous reset correctly, ensuring that both the GBHR and the PHT are reset when areset is high.
```

```code
module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [6:0] gbhr;
reg [6:0] gbhr_next;

reg [1:0] pht [127:0];
reg [1:0] pht_next [127:0];

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbhr <= 7'd0;
        for (i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else begin
        gbhr <= gbhr_next;
        for (i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    gbhr_next = gbhr;
    for (i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end

    // Calculate index into PHT
    reg [6:0] predict_index;
    reg [6:0] train_index;
    assign predict_index = predict_pc ^ gbhr;
    assign train_index = train_pc ^ train_history;

    // Prediction
    if (predict_valid) begin
        // Update GBHR based on prediction
        if (pht[predict_index] >= 2'd2) begin // Taken
            gbhr_next[0] = 1'b1;
        end else begin // Not Taken
            gbhr_next[0] = 1'b0;
        end
        // Shift in the new bit
        gbhr_next[6:1] = gbhr[5:0];
    end

    // Training
    if (train_valid) begin
        if (train_mispredicted) begin
            // Recovery: restore GBHR to its state after the mispredicted branch
            gbhr_next = train_history;
        end

        // Update PHT
        if (train_taken) begin
            if (pht[train_index] != 2'd3) begin
                pht_next[train_index] = pht[train_index] + 1;
            end
        end else begin
            if (pht[train_index] != 2'd0) begin
                pht_next[train_index] = pht[train_index] - 1;
            end
        end
    end
end

assign predict_taken = (pht[predict_pc ^ gbhr] >= 2'd2) ? 1'b1 : 1'b0;
assign predict_history = gbhr;

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
