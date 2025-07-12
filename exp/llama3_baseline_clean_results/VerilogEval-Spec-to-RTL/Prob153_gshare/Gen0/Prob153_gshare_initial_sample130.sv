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
reg [6:0] global_history_next;
reg [6:0] pht_index;
reg [1:0] pht_value;
reg [1:0] pht_value_next;
reg [127:0][1:0] pht;
reg [127:0][1:0] pht_next;

assign pht_index = {predict_pc[6], predict_pc[5], predict_pc[4], predict_pc[3], predict_pc[2], predict_pc[1], predict_pc[0]} ^ global_history;
assign pht_value = pht[pht_index];

always @(*) begin
    global_history_next = global_history;
    pht_next = pht;

    if (train_valid) begin
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
        if (train_taken) begin
            if (pht[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] == 0) begin
                pht_next[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] = 1;
            end else if (pht[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] == 1) begin
                pht_next[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] = 2;
            end else if (pht[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] == 2) begin
                pht_next[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] = 3;
            end
        end else begin
            if (pht[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] == 3) begin
                pht_next[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] = 2;
            end else if (pht[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] == 2) begin
                pht_next[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] = 1;
            end else if (pht[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] == 1) begin
                pht_next[train_pc[6] ^ train_pc[5] ^ train_pc[4] ^ train_pc[3] ^ train_pc[2] ^ train_pc[1] ^ train_pc[0] ^ train_history] = 0;
            end
        end
    end

    if (predict_valid && !train_valid) begin
        if (pht_value == 2 || pht_value == 3) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        pht <= '{default: 2};
    end else begin
        global_history <= global_history_next;
        pht <= pht_next;
    end
end

assign predict_taken = (pht_value == 2 || pht_value == 3);
assign predict_history = global_history;

endmodule