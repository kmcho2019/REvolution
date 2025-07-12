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
reg predict_taken_reg;

// Pattern History Table (PHT)
reg [1:0] pht [127:0];

// Asynchronous active-high reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else if (clk) begin
        global_history <= global_history_next;
        pht[pht_index] <= pht_entry_next;
    end
end

// Generate index for PHT
always @(*) begin
    pht_index = (predict_pc ^ global_history);
    pht_index_next = (train_pc ^ train_history);
end

// Predict branch direction
always @(*) begin
    if (predict_valid) begin
        pht_entry = pht[pht_index];
        predict_taken_reg = (pht_entry == 2'b11 || pht_entry == 2'b10);
        predict_taken = predict_taken_reg;
        predict_history = global_history;
        global_history_next = (predict_taken_reg) ? (global_history << 1 | 1'b1) : (global_history << 1);
    end else begin
        predict_taken_reg = 1'b0;
        predict_history = 7'b0;
        global_history_next = global_history;
    end
end

// Train branch predictor
always @(*) begin
    if (train_valid) begin
        pht_entry_next = pht[pht_index_next];
        if (train_mispredicted) begin
            if (train_taken) begin
                pht_entry_next = (pht_entry_next == 2'b11) ? 2'b11 : pht_entry_next + 1'b1;
            end else begin
                pht_entry_next = (pht_entry_next == 2'b00) ? 2'b00 : pht_entry_next - 1'b1;
            end
            global_history_next = train_history;
        end else if (train_taken) begin
            pht_entry_next = (pht_entry_next == 2'b11) ? 2'b11 : pht_entry_next + 1'b1;
        end else begin
            pht_entry_next = (pht_entry_next == 2'b00) ? 2'b00 : pht_entry_next - 1'b1;
        end
    end else begin
        pht_entry_next = pht[pht_index];
    end
end

endmodule