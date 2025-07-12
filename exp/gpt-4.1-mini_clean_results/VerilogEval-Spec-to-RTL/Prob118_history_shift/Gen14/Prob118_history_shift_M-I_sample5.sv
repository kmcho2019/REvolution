module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (train_mispredicted) begin
            // Rollback: load corrected history (train_history concatenated with train_taken)
            history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift left by 1 and insert new prediction at LSB
            history <= (history << 1) | predict_taken;
        end
        // else no update to history, clock gating possible at RTL level
    end

    assign predict_history = history;

endmodule