module TopModule(
    input               clk,
    input               areset,

    input               predict_valid,
    input       [6:0]   predict_pc,
    output reg          predict_taken,
    output reg  [6:0]   predict_history,

    input               train_valid,
    input               train_taken,
    input               train_mispredicted,
    input       [6:0]   train_history,
    input       [6:0]   train_pc
);

reg     [6:0]   ghreg;  // Global history register
reg     [6:0]   ghreg_next;  // Next value of global history register
reg     [6:0]   index;  // Index of PHT table
reg     [1:0]   pht_table [127:0];  // Pattern history table (PHT)
reg     [1:0]   pht_table_next [127:0];  // Next value of PHT table

always @(*) begin
    ghreg_next = ghreg;
    if (predict_valid) begin
        ghreg_next = {ghreg[5:0], predict_taken};
    end
    if (train_valid && train_mispredicted) begin
        ghreg_next = train_history;
    end
end

always @(*) begin
    index = predict_pc ^ ghreg;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghreg <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht_table[i] <= 2'b01;  // Initialize PHT table with weakly taken
        end
    end else begin
        ghreg <= ghreg_next;
        for (int i = 0; i < 128; i++) begin
            pht_table[i] <= pht_table_next[i];
        end
    end
end

always @(*) begin
    predict_taken = (pht_table[index] >= 2'b02);
    predict_history = ghreg;
    for (int i = 0; i < 128; i++) begin
        pht_table_next[i] = pht_table[i];
    end
    if (train_valid) begin
        case (pht_table[train_pc ^ train_history])
            2'b00: pht_table_next[train_pc ^ train_history] = (train_taken) ? 2'b01 : 2'b00;
            2'b01: pht_table_next[train_pc ^ train_history] = (train_taken) ? 2'b10 : 2'b00;
            2'b10: pht_table_next[train_pc ^ train_history] = (train_taken) ? 2'b11 : 2'b01;
            2'b11: pht_table_next[train_pc ^ train_history] = (train_taken) ? 2'b11 : 2'b10;
        endcase
    end
end

endmodule