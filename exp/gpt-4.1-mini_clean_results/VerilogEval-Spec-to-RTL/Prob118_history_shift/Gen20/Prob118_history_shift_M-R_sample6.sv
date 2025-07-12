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

    reg [31:0] next_predict_history;

    // Combinational logic for next history value
    always @(*) begin
        if (train_mispredicted) begin
            next_predict_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            next_predict_history = {predict_history[30:0], predict_taken};
        end else begin
            next_predict_history = predict_history;
        end
    end

    // Sequential logic for state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else begin
            predict_history <= next_predict_history;
        end
    end

endmodule