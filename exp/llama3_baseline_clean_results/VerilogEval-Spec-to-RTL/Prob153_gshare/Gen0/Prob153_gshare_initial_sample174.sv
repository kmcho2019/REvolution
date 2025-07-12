module TopModule (
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
reg [6:0] predict_history_reg;
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        predict_history_reg <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            global_history <= train_history;
        end
        pht[{predict_pc[6:0] ^ global_history[6:0]}] <=
            (pht[{predict_pc[6:0] ^ global_history[6:0]}] == 2'b11 && train_taken)? 2'b11 :
            (pht[{predict_pc[6:0] ^ global_history[6:0]}] == 2'b00 &&!train_taken)? 2'b00 :
            (train_taken)? pht[{predict_pc[6:0] ^ global_history[6:0]}] + 1'b1 :
            pht[{predict_pc[6:0] ^ global_history[6:0]}] - 1'b1;
    end else if (predict_valid) begin
        predict_history_reg <= global_history;
        global_history <= (global_history << 1) | predict_taken;
    end
end

always @(*) begin
    predict_taken = (pht[{predict_pc[6:0] ^ global_history[6:0]}] >= 2'b10);
    predict_history = predict_history_reg;
end

endmodule