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

// Define the size of the PHT
parameter PHT_SIZE = 128;

// Define the width of the saturating counters
parameter COUNTER_WIDTH = 2;

// Define the width of the pc and global history
parameter PC_WIDTH = 7;
parameter HISTORY_WIDTH = 7;

// Define the type for the saturating counters
reg [COUNTER_WIDTH-1:0] pht [PHT_SIZE-1:0];

// Define the global branch history register
reg [HISTORY_WIDTH-1:0] global_history;

// Define the index into the PHT
wire [6:0] index;

// Compute the index into the PHT
assign index = {predict_pc[6:1] ^ predict_history[6:1]};

// Update the PHT based on the training inputs
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < PHT_SIZE; i++) begin
            pht[i] <= 2'b00;
        end
        global_history <= 7'b0;
    end else if (train_valid) begin
        // Update the PHT
        if (train_taken && !train_mispredicted) begin
            if (pht[train_pc[6:1] ^ train_history[6:1]] != 2'b11) begin
                pht[train_pc[6:1] ^ train_history[6:1]] <= pht[train_pc[6:1] ^ train_history[6:1]] + 1'b1;
            end
        end else if (!train_taken && !train_mispredicted) begin
            if (pht[train_pc[6:1] ^ train_history[6:1]] != 2'b00) begin
                pht[train_pc[6:1] ^ train_history[6:1]] <= pht[train_pc[6:1] ^ train_history[6:1]] - 1'b1;
            end
        end

        // Update the global history register
        if (train_mispredicted) begin
            global_history <= train_history;
        end
    end else if (predict_valid) begin
        // Update the global history register
        global_history <= {global_history[5:0], predict_taken};
    end
end

// Produce the predicted branch direction and state of the branch history register
assign predict_taken = (pht[predict_pc[6:1] ^ predict_history[6:1]] >= 2'b10);
assign predict_history = global_history;

endmodule