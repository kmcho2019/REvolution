module TopModule(
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [31:0] static_history;
reg [0:0]  dynamic_history;

reg clk_enable;

always @(*) begin
    clk_enable = predict_valid || train_mispredicted;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        static_history <= 32'd0;
        dynamic_history <= 1'b0;
    end else if (clk_enable) begin
        if (train_mispredicted) begin
            static_history <= train_history;
            dynamic_history <= train_taken;
        end else if (predict_valid) begin
            dynamic_history <= predict_taken;
        end
    end
end

assign predict_history = {static_history[30:0], dynamic_history};

endmodule