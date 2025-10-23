module TopModule(
    input           clk,
    input           areset,

    input           predict_valid,
    input   [6:0]    predict_pc,
    output          predict_taken,
    output  [6:0]   predict_history,

    input           train_valid,
    input           train_taken,
    input           train_mispredicted,
    input   [6:0]    train_history,
    input   [6:0]    train_pc
);

reg [6:0] global_history;
reg [6:0] global_history_next;
reg [6:0] pht_index;
reg [1:0] pht_entry;
reg [1:0] pht_entry_next;

reg [127:0][1:0] pht;

assign pht_index = predict_pc[6:0] ^ global_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        global_history <= global_history_next;

        if (train_valid) begin
            pht[pht_index] <= pht_entry_next;
        end
    end
end

always @(*) begin
    global_history_next = global_history;

    if (predict_valid) begin
        if (pht[pht_index] >= 2'b02) begin
            predict_taken = 1'b1;
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            predict_taken = 1'b0;
            global_history_next = {global_history[5:0], 1'b0};
        end
    end

    if (train_valid) begin
        if (train_taken) begin
            pht_entry_next = pht[train_pc[6:0] ^ train_history];
            if (pht_entry_next != 2'b11) begin
                pht_entry_next = pht_entry_next + 1;
            end
        end else begin
            pht_entry_next = pht[train_pc[6:0] ^ train_history];
            if (pht_entry_next != 2'b00) begin
                pht_entry_next = pht_entry_next - 1;
            end
        end

        if (train_mispredicted) begin
            global_history_next = train_history;
        end
    end
end

assign predict_history = global_history;

endmodule