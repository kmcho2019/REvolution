module TopModule(
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

// Define the size of the pattern history table (PHT)
localparam PHT_SIZE = 128;

// Define the size of the global branch history register
localparam HISTORY_SIZE = 7;

// Define the number of bits for the saturating counter
localparam COUNTER_SIZE = 2;

// Define the PHT as a 2D array of saturating counters
reg [COUNTER_SIZE-1:0] pht [PHT_SIZE-1:0];

// Define the global branch history register
reg [HISTORY_SIZE-1:0] history;

// Define the index for the PHT
wire [6:0] index;

// Define the predicted branch direction
reg predict_taken_reg;

// Define the predicted branch history
reg [HISTORY_SIZE-1:0] predict_history_reg;

// Calculate the index for the PHT by hashing the pc and global branch history
assign index = predict_pc ^ history;

// Predict the branch direction based on the counter value
always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken_reg <= 0;
        predict_history_reg <= 0;
    end else if (predict_valid) begin
        predict_taken_reg <= (pht[index] > 1) ? 1 : 0;
        predict_history_reg <= history;
    end
end

// Update the global branch history register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 0;
    end else if (predict_valid) begin
        history <= {history[5:0], predict_taken_reg};
    end else if (train_valid && train_mispredicted) begin
        history <= train_history;
    end
end

// Update the PHT
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < PHT_SIZE; i++) begin
            pht[i] <= 0;
        end
    end else if (train_valid) begin
        wire [6:0] train_index = train_pc ^ train_history;
        if (train_taken) begin
            if (pht[train_index] < (2**COUNTER_SIZE-1)) begin
                pht[train_index] <= pht[train_index] + 1;
            end
        end else begin
            if (pht[train_index] > 0) begin
                pht[train_index] <= pht[train_index] - 1;
            end
        end
    end
end

// Assign the outputs
assign predict_taken = predict_taken_reg;
assign predict_history = predict_history_reg;

endmodule