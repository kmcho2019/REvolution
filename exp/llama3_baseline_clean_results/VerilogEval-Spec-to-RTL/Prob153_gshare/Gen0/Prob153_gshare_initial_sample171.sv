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

// Define the size of the Pattern History Table (PHT)
localparam PHT_SIZE = 128;

// Define the width of the saturating counters in the PHT
localparam COUNTER_WIDTH = 2;

// Define the width of the global branch history register
localparam HISTORY_WIDTH = 7;

// Define the width of the pc
localparam PC_WIDTH = 7;

// Declare the PHT
reg [COUNTER_WIDTH-1:0] pht [PHT_SIZE-1:0];

// Declare the global branch history register
reg [HISTORY_WIDTH-1:0] history;

// Declare the internal signals
reg [COUNTER_WIDTH-1:0] current_counter;
reg [PHT_SIZE-1:0] index;
reg [HISTORY_WIDTH-1:0] next_history;

// Combinational logic to hash the pc and history into an index
always @(*) begin
    index = {predict_pc[6:1] ^ predict_pc[0], history[6:1] ^ history[0]};
end

// Combinational logic to access the PHT
always @(*) begin
    current_counter = pht[index];
end

// Sequential logic to update the PHT and the global branch history register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset the PHT and the global branch history register
        for (int i = 0; i < PHT_SIZE; i++) begin
            pht[i] <= 0;
        end
        history <= 0;
    end else begin
        // Update the PHT based on the training request
        if (train_valid) begin
            if (train_mispredicted) begin
                // If the branch was mispredicted, recover the global branch history register
                history <= train_history;
            end
            if (train_taken) begin
                // If the branch was taken, increment the saturating counter
                if (pht[train_pc[6:1] ^ train_pc[0]] < (2**COUNTER_WIDTH - 1)) begin
                    pht[train_pc[6:1] ^ train_pc[0]] <= pht[train_pc[6:1] ^ train_pc[0]] + 1;
                end
            end else begin
                // If the branch was not taken, decrement the saturating counter
                if (pht[train_pc[6:1] ^ train_pc[0]] > 0) begin
                    pht[train_pc[6:1] ^ train_pc[0]] <= pht[train_pc[6:1] ^ train_pc[0]] - 1;
                end
            end
        end

        // Update the global branch history register based on the prediction request
        if (predict_valid) begin
            if (train_valid && train_mispredicted) begin
                // If training and prediction occur in the same cycle, and the branch was mispredicted, do not update the global branch history register
            end else begin
                // Update the global branch history register
                history <= {history[5:0], predict_taken};
            end
        end
    end
end

// Combinational logic to generate the prediction output
always @(*) begin
    if (current_counter >= 2) begin
        predict_taken = 1;
    end else begin
        predict_taken = 0;
    end
    predict_history = history;
end

endmodule