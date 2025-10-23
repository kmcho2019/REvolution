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

    // next_state logic using conditional operators with misprediction priority
    assign next_state = train_mispredicted ? {train_history[30:0], train_taken} :
                        predict_valid     ? {history[30:0], predict_taken} :
                                            history;

    // Asynchronous reset and sequential update
    always @(posedge clk or posedge areset) begin
        if (areset)
            history <= 32'b0;
        else
            history <= next_state;
    end

    assign predict_history = history;

endmodule