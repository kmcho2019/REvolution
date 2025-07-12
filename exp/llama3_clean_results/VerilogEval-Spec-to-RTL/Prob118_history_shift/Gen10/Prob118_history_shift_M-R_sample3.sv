module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

reg [31:0] next_predict_history;

always @(*) begin
    case (1'b1)
        train_mispredicted: next_predict_history = {train_history, train_taken};
        predict_valid: next_predict_history = {predict_history[30:0], predict_taken};
        default: next_predict_history = predict_history;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_history <= 32'd0;
    end else begin
        predict_history <= next_predict_history;
    end
end

endmodule