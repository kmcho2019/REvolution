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

reg [6:0] ghregister;  // Global History Register
reg [6:0] ghregister_next;  // Next state of Global History Register
reg [6:0] ghregister_recovery;  // Recovery value for Global History Register
reg [127:0] pht;  // Pattern History Table
reg [1:0] pht_entry;  // Current PHT entry
reg [1:0] pht_entry_next;  // Next state of PHT entry

// Calculate index into PHT
reg [6:0] index;
assign index = predict_pc ^ ghregister;

// Initialize PHT and Global History Register
initial begin
    for (int i = 0; i < 128; i++) begin
        pht[i] = 2'b11;  // Initialize PHT entries to strongly taken
    end
    ghregister = 7'b0;  // Initialize Global History Register to 0
end

// Handle reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        ghregister <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b11;  // Reset PHT entries to strongly taken
        end
    end else if (clk) begin
        ghregister <= ghregister_next;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= pht[i];  // Default: no change
        end
    end
end

// Handle prediction
always @(posedge clk) begin
    if (predict_valid) begin
        pht_entry <= pht[index];  // Read current PHT entry
        if (pht_entry == 2'b11 || pht_entry == 2'b10) begin
            predict_taken <= 1'b1;  // Predict taken
        end else begin
            predict_taken <= 1'b0;  // Predict not taken
        end
        predict_history <= ghregister;  // Output current Global History Register
        ghregister_next <= {ghregister[5:0], predict_taken};  // Update Global History Register
    end
end

// Handle training
always @(posedge clk) begin
    if (train_valid) begin
        reg [6:0] train_index;
        train_index = train_pc ^ train_history;  // Calculate index into PHT
        if (train_mispredicted) begin
            ghregister_recovery <= train_history;  // Store recovery value for Global History Register
            ghregister_next <= ghregister_recovery;  // Recover Global History Register
        end else begin
            ghregister_next <= ghregister;  // No change to Global History Register
        end
        if (train_taken) begin
            if (pht[train_index]!= 2'b11) begin
                pht[train_index] <= pht[train_index] + 1;  // Increment PHT entry
            end
        end else begin
            if (pht[train_index]!= 2'b00) begin
                pht[train_index] <= pht[train_index] - 1;  // Decrement PHT entry
            end
        end
    end else begin
        ghregister_next <= ghregister;  // No change to Global History Register
    end
end

endmodule