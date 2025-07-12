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

    reg [15:0] history_low;
    reg [15:0] history_high;

    // Combine two 16-bit registers to form 32-bit history, LSB is youngest branch
    assign predict_history = {history_high, history_low};

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_low  <= 16'b0;
            history_high <= 16'b0;
        end else if (train_mispredicted) begin
            // Load the corrected history on misprediction
            // Lower 16 bits from train_history[15:0]
            // Upper 16 bits from train_history[31:16]
            // Insert train_taken as the youngest bit (LSB)
            // So shift the train_history left by 1, add train_taken at LSB
            // Since predict_history[0] is youngest, this corresponds to:
            // train_history shifted left by 1 bit plus train_taken at LSB
            {history_high, history_low} <= {train_history, 1'b0} | {31'b0, train_taken};
        end else if (predict_valid) begin
            // On prediction, shift in predict_taken:
            // New history_low = shift left by 1, insert predict_taken at LSB
            // New history_high = shift left by 1, insert old MSB of history_low at LSB
            history_high <= {history_high[14:0], history_low[15]};
            history_low  <= {history_low[14:0], predict_taken};
        end
        // else hold state
    end

endmodule