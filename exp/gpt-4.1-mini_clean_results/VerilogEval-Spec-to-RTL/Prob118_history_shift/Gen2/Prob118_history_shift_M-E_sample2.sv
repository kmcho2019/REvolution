module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [32:0] history_reg;

    // Asynchronous reset, positive edge clock
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 33'b0;
        end else if (train_mispredicted) begin
            // Rollback history: train_history concatenated with train_taken
            history_reg <= {train_history, train_taken};
        end else if (predict_valid) begin
            // Shift left by 1, inserting predict_taken at LSB
            history_reg <= {history_reg[31:0], predict_taken};
        end
        // else hold state
    end

    // Output is lower 32 bits: bit 0 is youngest branch as required
    assign predict_history = history_reg[31:0];

endmodule