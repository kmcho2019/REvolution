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

reg [6:0] global_history;
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else if (train_valid && train_mispredicted) begin
        global_history <= train_history;
        if (pht[{train_pc[6:1], global_history[0]}] < 2'b11 && train_taken) begin
            pht[{train_pc[6:1], global_history[0]}] <= pht[{train_pc[6:1], global_history[0]}] + 1;
        end else if (pht[{train_pc[6:1], global_history[0]}] > 2'b00 && !train_taken) begin
            pht[{train_pc[6:1], global_history[0]}] <= pht[{train_pc[6:1], global_history[0]}] - 1;
        end
    end else if (predict_valid) begin
        global_history <= {global_history[5:0], predict_taken};
    end else if (train_valid && !train_mispredicted) begin
        if (pht[{train_pc[6:1], global_history[0]}] < 2'b11 && train_taken) begin
            pht[{train_pc[6:1], global_history[0]}] <= pht[{train_pc[6:1], global_history[0]}] + 1;
        end else if (pht[{train_pc[6:1], global_history[0]}] > 2'b00 && !train_taken) begin
            pht[{train_pc[6:1], global_history[0]}] <= pht[{train_pc[6:1], global_history[0]}] - 1;
        end
    end
end

always @(*) begin
    if (predict_valid) begin
        predict_taken = (pht[{predict_pc[6:1], global_history[0]}] >= 2'b10);
        predict_history = global_history;
    end else begin
        predict_taken = 1'b0;
        predict_history = 7'b0;
    end
end

endmodule