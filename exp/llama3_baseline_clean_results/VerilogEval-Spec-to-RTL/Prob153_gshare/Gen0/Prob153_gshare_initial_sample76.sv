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

    reg [6:0] train_pht_index;
    reg [1:0] train_pht_value;
    reg [1:0] train_pht_value_next;

    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    reg [127:0] [1:0] pht_table;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
        end else begin
            global_history <= global_history_next;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pht_table <= {128{2'b0}};
        end else if (train_valid) begin
            if (train_taken && !train_mispredicted) begin
                if (pht_table[train_pht_index] == 2'b11) begin
                    pht_table[train_pht_index] <= 2'b11;
                end else begin
                    pht_table[train_pht_index] <= pht_table[train_pht_index] + 1;
                end
            end else if (!train_taken && !train_mispredicted) begin
                if (pht_table[train_pht_index] == 2'b00) begin
                    pht_table[train_pht_index] <= 2'b00;
                end else begin
                    pht_table[train_pht_index] <= pht_table[train_pht_index] - 1;
                end
            end else if (train_mispredicted) begin
                if (train_taken) begin
                    if (pht_table[train_pht_index] == 2'b11) begin
                        pht_table[train_pht_index] <= 2'b11;
                    end else begin
                        pht_table[train_pht_index] <= pht_table[train_pht_index] + 1;
                    end
                end else begin
                    if (pht_table[train_pht_index] == 2'b00) begin
                        pht_table[train_pht_index] <= 2'b00;
                    end else begin
                        pht_table[train_pht_index] <= pht_table[train_pht_index] - 1;
                    end
                end
            end
        end
    end

    assign pht_index = predict_pc[6:0] ^ global_history;
    assign train_pht_index = train_pc[6:0] ^ train_history;

    assign pht_value = pht_table[pht_index];
    assign train_pht_value = pht_table[train_pht_index];

    always @(posedge clk) begin
        if (predict_valid) begin
            if (pht_value == 2'b11 || pht_value == 2'b10) begin
                predict_taken_reg <= 1;
            end else begin
                predict_taken_reg <= 0;
            end
            predict_history_reg <= global_history;
            if (predict_taken_reg) begin
                global_history_next <= {global_history[5:0], 1'b1};
            end else begin
                global_history_next <= {global_history[5:0], 1'b0};
            end
        end else begin
            predict_taken_reg <= predict_taken_reg;
            predict_history_reg <= predict_history_reg;
            if (train_mispredicted && train_valid) begin
                global_history_next <= train_history;
            end else begin
                global_history_next <= global_history;
            end
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule