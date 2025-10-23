module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [6:0] global_history;
reg [6:0] pht_index;
reg [1:0] pht_entry;
reg predict_taken_reg;

reg [127:0][1:0] pattern_history_table;

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (i = 0; i < 128; i++) begin
            pattern_history_table[i] <= 2'b01;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            global_history <= train_history;
        end
        pht_index <= train_pc ^ train_history;
        if (train_taken) begin
            if (pattern_history_table[pht_index] < 2'b11) begin
                pattern_history_table[pht_index] <= pattern_history_table[pht_index] + 1'b1;
            end
        end else begin
            if (pattern_history_table[pht_index] > 2'b00) begin
                pattern_history_table[pht_index] <= pattern_history_table[pht_index] - 1'b1;
            end
        end
        if (predict_valid) begin
            predict_history <= global_history;
        end
    end else if (predict_valid) begin
        pht_index <= predict_pc ^ global_history;
        predict_taken_reg <= (pattern_history_table[pht_index] >= 2'b10);
        if (predict_taken_reg) begin
            global_history <= {global_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
        end
        predict_history <= global_history;
    end else if (!predict_valid && !train_valid) begin
        if (global_history[6]) begin
            global_history <= {global_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
        end
    end
end

always @(*) begin
    predict_taken = predict_taken_reg;
end

endmodule