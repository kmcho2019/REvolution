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

reg [6:0] gh; // global history register
reg [6:0] gh_next; // next global history register
reg [1:0] pht [127:0]; // pattern history table
reg [1:0] pht_next [127:0]; // next pattern history table

assign predict_taken = (pht[{predict_pc[6:1], gh[6:1]}] >= 2'b2) ? 1'b1 : 1'b0;
assign predict_history = gh;

always @(*) begin
    gh_next = gh;
    for (int i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end
    if (train_valid) begin
        pht_next[{train_pc[6:1], train_history[6:1]}] = (train_taken) ? ((pht[{train_pc[6:1], train_history[6:1]}] == 2'b11) ? 2'b11 : pht[{train_pc[6:1], train_history[6:1]}] + 1'b1) : ((pht[{train_pc[6:1], train_history[6:1]}] == 2'b00) ? 2'b00 : pht[{train_pc[6:1], train_history[6:1]}] - 1'b1);
        if (train_mispredicted) begin
            gh_next = train_history;
        end
    end
    if (predict_valid && !train_mispredicted) begin
        gh_next[0] = predict_taken;
        gh_next[6:1] = gh[5:0];
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        gh <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        gh <= gh_next;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

endmodule