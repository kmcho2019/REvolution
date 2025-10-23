module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (train_mispredicted) begin
            // Load actual branch result into bit 0 and shift older bits right
            history_reg <= {train_taken, train_history[31:1]};
        end else if (predict_valid) begin
            // Shift right by one, inserting predict_taken at LSB (bit 0)
            history_reg <= {predict_taken, history_reg[31:1]};
        end
        // else hold state
    end

    assign predict_history = history_reg;

endmodule