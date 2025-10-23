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

reg [127:0][1:0] pht;
reg [127:0][1:0] pht_next;

always @(*) begin
    history_next = history;
    if (train_valid && train_mispredicted) begin
        history_next = train_history;
    end else if (predict_valid) begin
        history_next = {history[5:0], predict_taken};
    end
end

always @(*) begin
    pht_next = pht;
    if (train_valid) begin
        reg [6:0] index;
        index = predict_pc[6:0] ^ history;
        if (train_taken) begin
            if (pht[index] < 2'b11) begin
                pht_next[index] = pht[index] + 1'b1;
            end
        end else begin
            if (pht[index] > 2'b00) begin
                pht_next[index] = pht[index] - 1'b1;
            end
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        pht <= {128{2'b01}};
    end else begin
        history <= history_next;
        pht <= pht_next;
    end
end

always @(*) begin
    reg [6:0] index;
    index = predict_pc[6:0] ^ history;
    predict_taken = (pht[index] >= 2'b10);
    predict_history = history;
end

endmodule