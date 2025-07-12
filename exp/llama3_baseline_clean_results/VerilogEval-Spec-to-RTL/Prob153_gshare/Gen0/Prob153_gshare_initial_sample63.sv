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

reg [6:0] global_branch_history;
reg [6:0] global_branch_history_next;
reg [1:0] pht [127:0];
reg [1:0] pht_next [127:0];

always @(*) begin
    global_branch_history_next = global_branch_history;
    for (int i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_branch_history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else begin
        global_branch_history <= global_branch_history_next;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    reg [6:0] index;
    reg [1:0] pht_value;
    reg predict_taken_temp;

    if (predict_valid) begin
        index = {predict_pc[6:1], global_branch_history[0]};
        pht_value = pht[index];
        predict_taken_temp = (pht_value == 2'd2 || pht_value == 2'd3);
        global_branch_history_next = {global_branch_history[5:0], predict_taken_temp};
    end else if (train_valid) begin
        index = {train_pc[6:1], train_history[0]};
        if (train_mispredicted) begin
            global_branch_history_next = train_history;
        end
        if (train_taken) begin
            if (pht[index] != 2'd3) begin
                pht_next[index] = pht[index] + 1'd1;
            end
        end else begin
            if (pht[index] != 2'd0) begin
                pht_next[index] = pht[index] - 1'd1;
            end
        end
    end

    assign predict_taken = predict_taken_temp;
    assign predict_history = global_branch_history;
end

endmodule