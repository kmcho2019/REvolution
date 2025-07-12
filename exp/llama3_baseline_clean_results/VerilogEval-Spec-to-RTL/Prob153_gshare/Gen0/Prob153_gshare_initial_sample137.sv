module TopModule(
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

reg [6:0] history;
reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            history <= train_history;
        end else if (train_taken) begin
            history <= {history[5:0], 1'b1};
        end else begin
            history <= {history[5:0], 1'b0};
        end
        if (pht[{train_pc[6:2], train_history[6:2]}] != 2'b11 && train_taken) begin
            pht[{train_pc[6:2], train_history[6:2]}] <= pht[{train_pc[6:2], train_history[6:2]}] + 2'b01;
        end else if (pht[{train_pc[6:2], train_history[6:2]}] != 2'b00 && !train_taken) begin
            pht[{train_pc[6:2], train_history[6:2]}] <= pht[{train_pc[6:2], train_history[6:2]}] - 2'b01;
        end
    end else if (predict_valid) begin
        if (predict_taken) begin
            history <= {history[5:0], 1'b1};
        end else begin
            history <= {history[5:0], 1'b0};
        end
    end
end

always @(*) begin
    predict_taken = (pht[{predict_pc[6:2], history[6:2]}] >= 2'b10);
    predict_history = history;
end

endmodule