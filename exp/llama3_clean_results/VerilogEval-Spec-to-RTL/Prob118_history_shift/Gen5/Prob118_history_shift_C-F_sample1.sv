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

wire update_mispredicted = train_mispredicted;
wire update_predict = ~train_mispredicted & predict_valid;

wire [31:0] next_history_mispredicted = {train_history, train_taken};
wire [31:0] next_history_predict = {predict_history[30:0], predict_taken};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_history <= 32'd0;
    end else if (update_mispredicted) begin
        predict_history <= next_history_mispredicted;
    end else if (update_predict) begin
        predict_history <= next_history_predict;
    end
end

endmodule