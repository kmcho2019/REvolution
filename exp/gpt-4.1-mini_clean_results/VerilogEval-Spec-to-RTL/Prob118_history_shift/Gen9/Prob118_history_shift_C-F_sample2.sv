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

    // Next state combinational signals
    wire [31:0] predicted_next = {predict_history[30:0], predict_taken};
    wire [31:0] mispredicted_next = {train_history[30:0], train_taken};
    wire [31:0] next_history;

    // Priority: misprediction rollback > prediction update > hold
    assign next_history = train_mispredicted ? mispredicted_next :
                          predict_valid     ? predicted_next :
                                              predict_history;

    // Update only when state changes to reduce toggling
    wire update_enable = (train_mispredicted | predict_valid) &&
                         (next_history != predict_history);

    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_history;
        // else hold the current value (no toggling)
    end

endmodule