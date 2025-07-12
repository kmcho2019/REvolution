module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    wire update_enable = predict_valid | train_mispredicted;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            if (train_mispredicted) begin
                // On misprediction, load corrected history with train_history shifted left by 1 bit + train_taken at LSB
                predict_history <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // On prediction, shift in predict_taken
                predict_history <= {predict_history[30:0], predict_taken};
            end
        end
        // else hold state to reduce toggling and power
    end

endmodule