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

reg [6:0] history_reg;
reg [6:0] history_reg_next;
reg [6:0] pht_index;
reg [1:0] pht_entry;
reg [1:0] pht_entry_next;

// PHT table
reg [1:0] pht_table [127:0];

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        history_reg <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht_table[i] <= 2'd0;
        end
    end else if (clk) begin
        history_reg <= history_reg_next;
        for (int i = 0; i < 128; i++) begin
            if (train_valid && (train_pc ^ train_history) == i) begin
                pht_table[i] <= pht_entry_next;
            end
        end
    end
end

// Calculate PHT index
always @(*) begin
    pht_index = predict_pc ^ history_reg;
end

// PHT entry logic
always @(*) begin
    pht_entry = pht_table[pht_index];
end

// Prediction logic
always @(*) begin
    predict_taken = (pht_entry == 2'd2 || pht_entry == 2'd3);
    predict_history = history_reg;
end

// Update branch history register
always @(*) begin
    history_reg_next = history_reg;
    if (train_valid && train_mispredicted) begin
        history_reg_next = train_history;
    end else if (predict_valid && predict_taken) begin
        history_reg_next = {history_reg[5:0], 1'b1};
    end else if (predict_valid && ~predict_taken) begin
        history_reg_next = {history_reg[5:0], 1'b0};
    end
end

// Update PHT entry
always @(*) begin
    pht_entry_next = pht_entry;
    if (train_valid) begin
        if (train_taken) begin
            if (pht_entry == 2'd3) begin
                pht_entry_next = pht_entry;
            end else begin
                pht_entry_next = pht_entry + 2'd1;
            end
        end else begin
            if (pht_entry == 2'd0) begin
                pht_entry_next = pht_entry;
            end else begin
                pht_entry_next = pht_entry - 2'd1;
            end
        end
    end
end

endmodule