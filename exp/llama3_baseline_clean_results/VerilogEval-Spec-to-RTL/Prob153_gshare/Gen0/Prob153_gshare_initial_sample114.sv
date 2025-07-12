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
reg [6:0] pht_index;
reg [1:0] saturating_counter;
reg [1:0] saturating_counter_next;

reg [127:0][1:0] pht;

always @(*) begin
    global_branch_history_next = global_branch_history;
    if (predict_valid) begin
        if (predict_taken) begin
            global_branch_history_next = {global_branch_history[5:0], 1'b1};
        end else begin
            global_branch_history_next = {global_branch_history[5:0], 1'b0};
        end
    end
    if (train_valid && train_mispredicted) begin
        global_branch_history_next = train_history;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_branch_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        global_branch_history <= global_branch_history_next;
        if (train_valid) begin
            pht_index = (predict_pc ^ global_branch_history);
            if (train_taken) begin
                if (pht[pht_index] != 2'b11) begin
                    pht[pht_index] <= pht[pht_index] + 1'b1;
                end
            end else begin
                if (pht[pht_index] != 2'b00) begin
                    pht[pht_index] <= pht[pht_index] - 1'b1;
                end
            end
        end
    end
end

assign pht_index = (predict_pc ^ global_branch_history);
assign saturating_counter = pht[pht_index];

assign predict_taken = (saturating_counter >= 2'b10);
assign predict_history = global_branch_history;

endmodule