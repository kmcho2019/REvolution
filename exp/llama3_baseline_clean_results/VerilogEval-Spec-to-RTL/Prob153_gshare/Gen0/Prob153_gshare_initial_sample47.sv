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

reg [6:0] gh;
reg [6:0] gh_next;
reg [127:0] [1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        gh <= 0;
        pht <= {128{2'b00}};
    end else begin
        gh <= gh_next;
        if (train_valid) begin
            pht[{predict_pc[6:0] ^ gh[6:0]}] <= (train_mispredicted)? 
                (pht[{train_pc[6:0] ^ train_history[6:0]}] == 2'b11)? 2'b11 : pht[{train_pc[6:0] ^ train_history[6:0]}] + 1 :
                (pht[{train_pc[6:0] ^ train_history[6:0]}] == 2'b00)? 2'b00 : pht[{train_pc[6:0] ^ train_history[6:0]}] - 1;
        end
    end
end

always @(*) begin
    gh_next = gh;
    if (predict_valid) begin
        predict_taken = (pht[{predict_pc[6:0] ^ gh[6:0]}] >= 2'b10);
        predict_history = gh;
        gh_next = (predict_taken)? {gh[5:0], 1'b1} : {gh[5:0], 1'b0};
    end
    if (train_valid && train_mispredicted) begin
        gh_next = train_history;
    end
end

endmodule