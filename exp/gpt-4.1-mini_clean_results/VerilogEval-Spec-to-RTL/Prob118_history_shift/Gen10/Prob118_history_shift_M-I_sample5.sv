module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg  [31:0] history;
    wire [31:0] next_state;
    wire        update_enable;

    // Update enable: only update history if a misprediction or valid prediction occurs
    assign update_enable = train_mispredicted | predict_valid;

    // next_state logic with misprediction priority
    assign next_state = train_mispredicted ? {train_history[30:0], train_taken} :
                        predict_valid     ? {history[30:0], predict_taken} :
                                            history;

    // Asynchronous reset and sequential update with clock enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            history <= 32'b0;
        else if (update_enable)
            history <= next_state;
    end

    assign predict_history = history;

endmodule