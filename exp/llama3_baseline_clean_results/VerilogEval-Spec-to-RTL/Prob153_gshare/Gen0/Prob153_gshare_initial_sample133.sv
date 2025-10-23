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
reg [127:0] [1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        pht <= {128{2'b0}};
    end else begin
        global_history <= global_history_next;
        if (train_valid) begin
            pht[pht_index] <= pht_value_next;
        end
    end
end

always @(*) begin
    pht_index = (predict_pc ^ global_history) % 128;
    pht_value = pht[pht_index];

    if (predict_valid) begin
        if (pht_value >= 2'b10) begin
            predict_taken = 1'b1;
        end else begin
            predict_taken = 1'b0;
        end
        predict_history = global_history;
        if (pht_value == 2'b11) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else if (pht_value == 2'b00) begin
            global_history_next = {global_history[5:0], 1'b0};
        end else begin
            global_history_next = global_history;
        end
    end else begin
        global_history_next = global_history;
    end

    if (train_valid) begin
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
        if (train_taken) begin
            if (pht[train_pc ^ train_history] == 2'b11) begin
                pht_value_next = 2'b11;
            end else begin
                pht_value_next = pht[train_pc ^ train_history] + 1'b1;
            end
        end else begin
            if (pht[train_pc ^ train_history] == 2'b00) begin
                pht_value_next = 2'b00;
            end else begin
                pht_value_next = pht[train_pc ^ train_history] - 1'b1;
            end
        end
    end else begin
        pht_value_next = pht[pht_index];
    end
end

endmodule