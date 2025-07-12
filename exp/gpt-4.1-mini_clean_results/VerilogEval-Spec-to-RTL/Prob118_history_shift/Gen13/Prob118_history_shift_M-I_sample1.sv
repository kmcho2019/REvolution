module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0]  predict_history
);

    wire update_enable = predict_valid | train_mispredicted;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load the corrected history on misprediction
            // Concatenate train_history shifted left by 1 bit with train_taken at LSB
            predict_history <= {train_history, 1'b0} | 32'b00000000000000000000000000000001 & {31'b0, train_taken};
            // The OR ensures the LSB is train_taken, higher bits are train_history shifted
            // Alternatively: {train_history[30:0], train_taken}
            // But the spec is: corrected history = train_history concatenated with train_taken as youngest bit
            // So actually the youngest bit is train_taken, then train_history forms older bits
            // So corrected history = {train_taken, train_history[31:1]} would reverse order
            // But spec says: predict_history[0] is youngest bit, so youngest = train_taken at LSB
            // So better to do: predict_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift left by 1 and insert predict_taken at LSB
            predict_history <= {predict_history[30:0], predict_taken};
        end
        // else hold state (clock gated by update_enable)
    end

endmodule