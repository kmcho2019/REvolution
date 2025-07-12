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
            // Roll back history: train_history shifted left by 1, insert train_taken at LSB
            predict_history <= (train_history << 1) | train_taken;
        end else if (predict_valid) begin
            // Shift in predict_taken at LSB
            predict_history <= (predict_history << 1) | predict_taken;
        end
        // else retain predict_history
    end

endmodule