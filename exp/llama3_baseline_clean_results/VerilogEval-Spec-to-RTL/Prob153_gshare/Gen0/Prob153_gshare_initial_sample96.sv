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
reg [6:0] history_next;
reg [6:0] predict_history_reg;

reg [7:0] pht [127:0];
reg [7:0] pht_next [127:0];

integer i;

always @(*) begin
    predict_taken = (pht[{predict_pc[6:1], predict_history[0]}] >= 2);
    predict_history = history;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 0;
        for (i = 0; i < 128; i++) begin
            pht[i] <= 0;
        end
    end else begin
        history <= history_next;
        for (i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    history_next = history;
    for (i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end

    if (train_valid) begin
        pht_next[{train_pc[6:1], train_history[0]}] = (train_taken) ? (pht[{train_pc[6:1], train_history[0]}] + 1) : (pht[{train_pc[6:1], train_history[0]}] - 1);
        pht_next[{train_pc[6:1], train_history[0]}] = (pht_next[{train_pc[6:1], train_history[0]}] > 3) ? 3 : (pht_next[{train_pc[6:1], train_history[0]}] < 0) ? 0 : pht_next[{train_pc[6:1], train_history[0]}];

        if (train_mispredicted) begin
            history_next = train_history;
        end
    end

    if (predict_valid && !train_mispredicted) begin
        history_next = {history[5:0], predict_taken};
    end
end

endmodule