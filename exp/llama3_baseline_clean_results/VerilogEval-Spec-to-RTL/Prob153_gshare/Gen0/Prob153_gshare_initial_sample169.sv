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
reg [6:0] pht_index_next;
reg [1:0] pht_entry;
reg [1:0] pht_entry_next;

reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
    end else begin
        if (train_valid && train_mispredicted) begin
            global_history <= train_history;
        end else if (predict_valid) begin
            global_history <= global_history_next;
        end
    end
end

always @(*) begin
    pht_index = {predict_pc[6:1], global_history[6]};
    pht_entry = pht[pht_index];

    predict_taken = (pht_entry == 2'b11 || pht_entry == 2'b10);
    predict_history = global_history;

    if (predict_valid) begin
        if (predict_taken) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end else begin
        global_history_next = global_history;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        if (train_valid) begin
            pht_index_next = {train_pc[6:1], train_history[6]};
            if (train_taken) begin
                if (pht[pht_index_next] != 2'b11) begin
                    pht[pht_index_next] <= pht[pht_index_next] + 1;
                end
            end else begin
                if (pht[pht_index_next] != 2'b00) begin
                    pht[pht_index_next] <= pht[pht_index_next] - 1;
                end
            end
        end
    end
end

endmodule