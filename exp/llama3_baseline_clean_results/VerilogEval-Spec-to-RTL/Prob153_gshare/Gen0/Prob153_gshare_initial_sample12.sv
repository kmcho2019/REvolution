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
reg [1:0] pht [127:0];
reg [1:0] pht_next [127:0];

assign predict_history = history;
assign predict_taken = (pht[{predict_pc[6:1], history[6:1]}] >= 2'b10) ? 1'b1 : 1'b0;

always @(*) begin
    history_next = history;
    if (predict_valid && !train_valid) begin
        history_next = {history[5:0], predict_taken};
    end else if (train_valid && train_mispredicted) begin
        history_next = train_history;
    end
end

always @(*) begin
    pht_next = pht;
    if (train_valid) begin
        pht_next[{train_pc[6:1], train_history[6:1]}] = (train_taken && train_mispredicted) ? (pht[{train_pc[6:1], train_history[6:1]}] == 2'b11) ? 2'b11 : pht[{train_pc[6:1], train_history[6:1]}] + 1'b1 :
                                            (train_taken && !train_mispredicted) ? pht[{train_pc[6:1], train_history[6:1]}] :
                                            (!train_taken && train_mispredicted) ? (pht[{train_pc[6:1], train_history[6:1]}] == 2'b00) ? 2'b00 : pht[{train_pc[6:1], train_history[6:1]}] - 1'b1 :
                                            (!train_taken && !train_mispredicted) ? pht[{train_pc[6:1], train_history[6:1]}] : pht[{train_pc[6:1], train_history[6:1]}];
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        history <= history_next;
        pht <= pht_next;
    end
end

endmodule