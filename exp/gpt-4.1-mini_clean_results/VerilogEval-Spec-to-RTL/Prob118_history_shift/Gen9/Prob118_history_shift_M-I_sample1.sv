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

    // Compute rollback_value only when needed
    wire [31:0] rollback_value = {train_history[30:0], train_taken};
    // Compute prediction_value only when needed
    wire [31:0] prediction_value = {predict_history[30:0], predict_taken};

    // Determine if update is needed and select next state with priority
    wire update_enable = train_mispredicted | predict_valid;
    wire [31:0] next_value = train_mispredicted ? rollback_value :
                            predict_valid     ? prediction_value :
                            predict_history;

    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_value;
        // else hold current value
    end

endmodule