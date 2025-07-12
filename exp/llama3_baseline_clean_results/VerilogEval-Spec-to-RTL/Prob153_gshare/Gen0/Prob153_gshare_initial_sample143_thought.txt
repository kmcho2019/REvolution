```thought
The module TopModule will implement a gshare branch predictor with 7-bit pc and 7-bit global history. The prediction interface will use the current global branch history register and the pc to index into a 128-entry table of two-bit saturating counters to make predictions. The branch history register will be updated at the next positive clock edge based on the prediction. The training interface will update the pattern history table (PHT) and recover the branch history register if the branch being trained is a misprediction. Training takes precedence over prediction when both occur in the same cycle. The reset is asynchronous active-high, and all sequential logic is triggered on the positive edge of the clock.
```

```verilog
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

reg [6:0] global_history;
reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else if (train_valid && train_mispredicted) begin
        global_history <= train_history;
    end else if (predict_valid) begin
        global_history <= {global_history[5:0], predict_taken};
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        reg [6:0] index;
        index = {predict_pc[6], global_history} ^ predict_pc;
        if (train_taken) begin
            if (pht[index] < 2'b11) begin
                pht[index] <= pht[index] + 2'b01;
            end
        end else begin
            if (pht[index] > 2'b00) begin
                pht[index] <= pht[index] - 2'b01;
            end
        end
    end
end

always @(*) begin
    reg [6:0] index;
    index = {predict_pc[6], global_history} ^ predict_pc;
    predict_taken = (pht[index] >= 2'b10);
    predict_history = global_history;
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
