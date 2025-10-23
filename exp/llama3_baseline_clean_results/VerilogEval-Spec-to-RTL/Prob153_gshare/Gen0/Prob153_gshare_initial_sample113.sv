module TopModule(
    input           clk,
    input           areset,
    input           predict_valid,
    input   [6:0]    predict_pc,
    output          predict_taken,
    output  [6:0]    predict_history,
    input           train_valid,
    input           train_taken,
    input           train_mispredicted,
    input   [6:0]    train_history,
    input   [6:0]    train_pc
);

reg [6:0] global_branch_history;
reg [6:0] global_branch_history_next;
reg [127:0] [1:0] pht;
reg [127:0] [1:0] pht_next;

assign predict_taken = (pht[{{predict_pc[6:1], predict_pc[0]} ^ global_branch_history}] == 2'b11) | (pht[{{predict_pc[6:1], predict_pc[0]} ^ global_branch_history}] == 2'b10);
assign predict_history = global_branch_history;

always @(*) begin
    global_branch_history_next = global_branch_history;
    if (predict_valid) begin
        if (predict_taken)
            global_branch_history_next = {global_branch_history[5:0], 1'b1};
        else
            global_branch_history_next = {global_branch_history[5:0], 1'b0};
    end
    if (train_valid && train_mispredicted) begin
        global_branch_history_next = train_history;
    end
end

always @(*) begin
    pht_next = pht;
    if (train_valid) begin
        reg [6:0] index;
        index = {{train_pc[6:1], train_pc[0]} ^ train_history};
        if (train_taken) begin
            if (pht[index] != 2'b11)
                pht_next[index] = pht[index] + 1'b1;
        end else begin
            if (pht[index] != 2'b00)
                pht_next[index] = pht[index] - 1'b1;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_branch_history <= 7'b0;
        pht <= '{default: 2'b01};
    end else begin
        global_branch_history <= global_branch_history_next;
        pht <= pht_next;
    end
end

endmodule