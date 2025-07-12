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
reg [6:0] predict_history_reg;

reg [7:0] pht_index;
reg [7:0] pht_index_next;
reg [1:0] pht_entry;
reg [1:0] pht_entry_next;

reg [6:0] pht [127:0];

always @(*) begin
    pht_index_next = {predict_pc[6:1], predict_pc[0]} ^ global_history;
    global_history_next = global_history;
    if (predict_valid) begin
        if (pht[pht_index_next] == 2'b11 || pht[pht_index_next] == 2'b10) begin
            predict_taken = 1'b1;
        end else begin
            predict_taken = 1'b0;
        end
        predict_history_reg = global_history;
        if (predict_taken) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end
    if (train_valid) begin
        pht_index = {train_pc[6:1], train_pc[0]} ^ train_history;
        if (train_taken) begin
            if (pht[pht_index] != 2'b11) begin
                pht_entry_next = pht[pht_index] + 1'b1;
            end else begin
                pht_entry_next = pht[pht_index];
            end
        end else begin
            if (pht[pht_index] != 2'b00) begin
                pht_entry_next = pht[pht_index] - 1'b1;
            end else begin
                pht_entry_next = pht[pht_index];
            end
        end
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        global_history <= global_history_next;
        for (int i = 0; i < 128; i++) begin
            if (i == pht_index) begin
                pht[i] <= pht_entry_next;
            end
        end
    end
end

assign predict_history = predict_history_reg;

endmodule