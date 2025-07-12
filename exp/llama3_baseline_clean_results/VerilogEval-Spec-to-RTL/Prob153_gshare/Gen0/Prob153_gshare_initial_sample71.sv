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

// Define the PHT table size
localparam PHT_SIZE = 128;

// Define the PHT entry size (2-bit saturating counter)
localparam PHT_ENTRY_SIZE = 2;

// Define the global branch history register size
localparam HISTORY_SIZE = 7;

// Define the hash function (XOR of pc and global history)
function [6:0] hash_func;
    input [6:0] pc;
    input [6:0] history;
    integer i;
    begin
        hash_func = 0;
        for (i = 0; i < HISTORY_SIZE; i++) begin
            hash_func[i] = pc[i] ^ history[i];
        end
    end
endfunction

// Define the PHT table
reg [PHT_ENTRY_SIZE-1:0] pht [PHT_SIZE-1:0];

// Define the global branch history register
reg [HISTORY_SIZE-1:0] history;

// Define the predicted branch direction
reg predict_taken_reg;

// Define the predicted history
reg [HISTORY_SIZE-1:0] predict_history_reg;

// Define the PHT index
wire [6:0] pht_index;

// Assign the PHT index
assign pht_index = hash_func(predict_pc, history);

// Predict the branch direction
always @(*) begin
    if (pht[pht_index] >= 2'b10) begin
        predict_taken_reg = 1'b1;
    end else begin
        predict_taken_reg = 1'b0;
    end
end

// Update the global branch history register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 0;
    end else if (train_valid && train_mispredicted) begin
        history <= train_history;
    end else if (predict_valid) begin
        history <= {history[5:0], predict_taken_reg};
    end
end

// Update the PHT table
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < PHT_SIZE; i++) begin
            pht[i] <= 2'b01; // Initialize PHT entries to weakly taken
        end
    end else if (train_valid) begin
        if (train_taken) begin
            if (pht[hash_func(train_pc, train_history)] != 2'b11) begin
                pht[hash_func(train_pc, train_history)] <= pht[hash_func(train_pc, train_history)] + 1'b1;
            end
        end else begin
            if (pht[hash_func(train_pc, train_history)] != 2'b00) begin
                pht[hash_func(train_pc, train_history)] <= pht[hash_func(train_pc, train_history)] - 1'b1;
            end
        end
    end
end

// Assign the predicted branch direction and history
assign predict_taken = predict_taken_reg;
assign predict_history = predict_history_reg;

// Update the predicted history
always @(posedge clk) begin
    predict_history_reg <= history;
end

endmodule