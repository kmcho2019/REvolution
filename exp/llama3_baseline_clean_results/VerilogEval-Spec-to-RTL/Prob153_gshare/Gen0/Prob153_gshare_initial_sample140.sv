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

    reg [7:0] pht_index;
    reg [7:0] pht_index_next;

    reg [1:0] pht_value;
    reg [1:0] pht_value_next;

    reg [127:0] [1:0] pht_table;
    reg [127:0] [1:0] pht_table_next;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            pht_table <= {128{2'b0}};
        end else begin
            global_history <= global_history_next;
            pht_table <= pht_table_next;
        end
    end

    always @(*) begin
        pht_index_next = {predict_pc[6:1], predict_pc[0] ^ global_history[0]};
        global_history_next = global_history;

        if (predict_valid) begin
            if (predict_pc[0] ^ global_history[0] == 1'b1) begin
                global_history_next[6:1] = global_history[5:0];
                global_history_next[0] = 1'b1;
            end else begin
                global_history_next[6:1] = global_history[5:0];
                global_history_next[0] = 1'b0;
            end
        end

        if (train_valid) begin
            if (train_mispredicted) begin
                global_history_next = train_history;
            end
        end

        if (train_valid) begin
            pht_index = {train_pc[6:1], train_pc[0] ^ train_history[0]};
            if (train_taken) begin
                if (pht_table[pht_index] == 2'b11) begin
                    pht_table_next = pht_table;
                end else begin
                    pht_table_next = pht_table;
                    pht_table_next[pht_index] = pht_table[pht_index] + 1'b1;
                end
            end else begin
                if (pht_table[pht_index] == 2'b00) begin
                    pht_table_next = pht_table;
                end else begin
                    pht_table_next = pht_table;
                    pht_table_next[pht_index] = pht_table[pht_index] - 1'b1;
                end
            end
        end else begin
            pht_table_next = pht_table;
        end
    end

    assign pht_value = pht_table[{predict_pc[6:1], predict_pc[0] ^ global_history[0]}];
    assign predict_taken = (pht_value[1] == 1'b1);
    assign predict_history = global_history;

endmodule