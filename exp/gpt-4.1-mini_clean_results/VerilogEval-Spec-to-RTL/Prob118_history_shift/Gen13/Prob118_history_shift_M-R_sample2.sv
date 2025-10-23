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

    // Combinational next state logic using continuous assignment
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                          predict_valid     ? {predict_history[30:0], predict_taken} :
                                              predict_history;

    // Sequential update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else begin
            predict_history <= next_history;
        end
    end

endmodule