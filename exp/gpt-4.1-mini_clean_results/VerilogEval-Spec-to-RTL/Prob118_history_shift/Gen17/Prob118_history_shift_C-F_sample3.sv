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

    reg [31:0] history;
    wire        update_enable = predict_valid | train_mispredicted;
    wire [31:0] next_history;

    // Combinational next state logic with priority misprediction > prediction
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                          predict_valid     ? {history[30:0], predict_taken} :
                                              history;

    // Sequential update with asynchronous reset and clock enable
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            history <= next_history;
        end
        // else retain current history (clock gating effect)
    end

    assign predict_history = history;

endmodule