module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0] predict_history
);

    wire update_enable = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction, load train_history shifted left by 1 and insert train_taken at LSB
            predict_history <= {train_history, 1'b0} | {31'b0, train_taken};
        end else if (predict_valid) begin
            // Shift left by 1 and insert predict_taken at LSB
            predict_history <= {predict_history[30:0], predict_taken};
        end
        // Otherwise hold predict_history
    end

endmodule