```thought
The gshare branch predictor module can be designed with a 7-bit global branch history register and a 128-entry table of two-bit saturating counters. The prediction interface takes in a 7-bit pc and produces the predicted branch direction and state of the branch history register. The training interface takes in the actual branch outcome, branch history, and pc, and updates the pattern history table (PHT) to improve future predictions. The branch history register is updated for predicted branches and recovered for mispredicted branches. The training operation takes precedence over prediction when both occur in the same cycle.
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

    reg [6:0] branch_history;
    reg [6:0] branch_history_next;
    reg [6:0] branch_history_recover;
    reg [127:0][1:0] pht;
    reg [127:0][1:0] pht_next;

    integer i;

    always @(*) begin
        branch_history_next = branch_history;
        if (predict_valid) begin
            if (predict_pc[6]) begin
                branch_history_next[6:0] = {branch_history[5:0], 1'b1};
            end else begin
                branch_history_next[6:0] = {branch_history[5:0], 1'b0};
            end
        end

        if (train_valid && train_mispredicted) begin
            branch_history_next = train_history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            branch_history <= 7'b0;
            pht <= {128{2'b0}};
        end else begin
            branch_history <= branch_history_next;

            if (train_valid) begin
                integer index;
                index = (predict_pc ^ branch_history) % 128;
                if (train_taken && pht[index] < 2'b11) begin
                    pht[index] <= pht[index] + 2'b01;
                end else if (!train_taken && pht[index] > 2'b00) begin
                    pht[index] <= pht[index] - 2'b01;
                end
            end
        end
    end

    always @(*) begin
        integer index;
        index = (predict_pc ^ branch_history) % 128;
        if (pht[index] >= 2'b10) begin
            predict_taken = 1'b1;
        end else begin
            predict_taken = 1'b0;
        end
        predict_history = branch_history;
    end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
