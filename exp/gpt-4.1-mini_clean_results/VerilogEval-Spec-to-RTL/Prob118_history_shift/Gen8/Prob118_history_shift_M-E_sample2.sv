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

    reg [32:0] history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 33'b0;
        end else if (train_mispredicted) begin
            // On misprediction, load full 33-bit with actual branch outcome + prior history
            history_reg <= {train_history, train_taken};
        end else if (predict_valid) begin
            // Shift left by one, inserting predict_taken at LSB
            history_reg <= {history_reg[31:0], predict_taken};
        end
        // else hold state
    end

    // Output is the lower 32 bits (youngest at bit 0)
    assign predict_history = history_reg[31:0];

endmodule