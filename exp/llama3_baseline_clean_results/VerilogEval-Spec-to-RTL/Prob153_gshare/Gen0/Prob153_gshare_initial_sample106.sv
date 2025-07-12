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
reg [6:0] pht_index;
reg [1:0] pht_value;
reg [127:0] [1:0] pht_table;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht_table[i] <= 0;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            global_history <= train_history;
        end
        pht_index <= {train_pc[6:1], train_pc[0] ^ global_history[0]};
        if (train_taken) begin
            if (pht_table[pht_index] != 2'b11) begin
                pht_table[pht_index] <= pht_table[pht_index] + 1;
            end
        end else begin
            if (pht_table[pht_index] != 2'b00) begin
                pht_table[pht_index] <= pht_table[pht_index] - 1;
            end
        end
    end else if (predict_valid) begin
        global_history <= {global_history[6:1], predict_taken};
    end
end

always @(posedge clk) begin
    pht_index <= {predict_pc[6:1], predict_pc[0] ^ global_history[0]};
    pht_value <= pht_table[pht_index];
    predict_taken <= pht_value[1];
    predict_history <= global_history;
end

endmodule