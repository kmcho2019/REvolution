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

    wire [31:0] next_history;
    wire        update_enable;

    // Determine if an update is needed (misprediction or valid prediction)
    assign update_enable = train_mispredicted | predict_valid;

    // Combinational next state logic with misprediction taking precedence
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                          predict_valid     ? {predict_history[30:0], predict_taken} :
                                              predict_history;

    // Sequential update with asynchronous reset and enable control to reduce unnecessary toggling
    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_history;
    end

endmodule