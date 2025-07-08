module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load history before mispredicted branch + actual branch outcome
            // train_history[31:1] are older history bits,
            // train_history[0] is youngest branch before mispredicted one,
            // So we replace the youngest branch (LSB) with train_taken.
            predict_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift in predict_taken at LSB (youngest branch)
            predict_history <= {predict_history[30:0], predict_taken};
        end
        // else hold state
    end

endmodule