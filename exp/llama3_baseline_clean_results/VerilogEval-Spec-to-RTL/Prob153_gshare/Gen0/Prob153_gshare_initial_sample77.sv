module TopModule (
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
reg [1:0] pht_entry;
reg [1:0] pht_entry_next;
reg predict_taken_reg;

// Pattern History Table (PHT)
reg [1:0] pht [127:0];

// Initialize PHT with all entries set to 2 (strongly taken)
initial begin
    for (int i = 0; i < 128; i++) begin
        pht[i] = 2;
    end
end

// Update global history register
always @(*) begin
    global_history_next = global_history;
    if (predict_valid) begin
        global_history_next = {global_history[5:0], predict_taken_reg};
    end
    if (train_valid && train_mispredicted) begin
        global_history_next = train_history;
    end
end

// Update PHT entry
always @(*) begin
    pht_entry_next = pht_entry;
    if (train_valid) begin
        pht_index = train_pc[6:0] ^ train_history;
        if (train_taken) begin
            if (pht[pht_index] < 2) begin
                pht_entry_next = pht[pht_index] + 1;
            end else begin
                pht_entry_next = 2;
            end
        end else begin
            if (pht[pht_index] > 0) begin
                pht_entry_next = pht[pht_index] - 1;
            end else begin
                pht_entry_next = 0;
            end
        end
    end
end

// Make prediction
always @(*) begin
    predict_taken_reg = 0;
    if (predict_valid) begin
        pht_index = predict_pc[6:0] ^ global_history;
        pht_entry = pht[pht_index];
        if (pht_entry >= 2) begin
            predict_taken_reg = 1;
        end
    end
end

// Update PHT and global history register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2;
        end
    end else begin
        global_history <= global_history_next;
        if (train_valid) begin
            pht[pht_index] <= pht_entry_next;
        end
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = global_history;

endmodule