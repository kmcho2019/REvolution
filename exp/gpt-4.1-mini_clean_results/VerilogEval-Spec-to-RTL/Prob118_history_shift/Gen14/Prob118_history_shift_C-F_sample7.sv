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

    // Next state combinational logic: misprediction update has priority
    wire [31:0] next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                              predict_valid      ? {predict_history[30:0], predict_taken} :
                                                   predict_history;

    // Update enable: only update when a valid update occurs (misprediction or prediction)
    wire update_enable = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            predict_history <= next_history;
        end
        // else retain the current history to reduce toggling (power optimization)
    end

endmodule