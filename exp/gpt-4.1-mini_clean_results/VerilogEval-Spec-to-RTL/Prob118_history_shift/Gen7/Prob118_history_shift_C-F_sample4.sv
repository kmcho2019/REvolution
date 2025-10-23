module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    // Next history candidates
    wire [31:0] rollback_history = {train_history[30:0], train_taken};
    wire [31:0] prediction_history = {predict_history[30:0], predict_taken};

    // Priority mux for next history value
    wire [31:0] next_history = train_mispredicted ? rollback_history :
                               predict_valid     ? prediction_history :
                                                  predict_history;

    // Enable update only on misprediction or valid prediction to reduce toggling
    wire update_enable = train_mispredicted | predict_valid;

    // Sequential block with async reset and gated updates
    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_history;
        // else hold state, no toggle
    end

endmodule