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

// Define the Pattern History Table (PHT) with 128 entries, each 2 bits wide
reg [1:0] pht [127:0];
// Initialize PHT to a default state (e.g., all weakly not taken)
integer i;
initial begin
    for (i = 0; i < 128; i++) begin
        pht[i] = 2'b01; // Weakly not taken
    end
end

// Define the 7-bit global branch history register
reg [6:0] global_history;

// Hashing function to generate the 7-bit index
function [6:0] hash(input [6:0] pc, input [6:0] history);
    integer i;
    reg [6:0] index;
    index = 0;
    for (i = 0; i < 7; i++) begin
        index[i] = pc[i] ^ history[i];
    end
    return index;
endfunction

// Update the global branch history register based on the predicted branch direction
always @(posedge clk) begin
    if (areset) begin
        global_history <= 0;
    end else if (predict_valid) begin
        // Update the global history register with the predicted branch direction
        global_history <= {global_history[5:0], predict_taken};
    end else if (train_mispredicted && train_valid) begin
        // Recover the branch history register to the state immediately after the mispredicting branch completes execution
        global_history <= train_history;
    end
end

// Predict the branch direction based on the PHT
always @(*) begin
    reg [6:0] index;
    index = hash(predict_pc, global_history);
    if (pht[index] >= 2'b10) begin
        // Strongly taken or weakly taken, predict taken
        predict_taken = 1'b1;
    end else begin
        // Weakly not taken or strongly not taken, predict not taken
        predict_taken = 1'b0;
    end
    predict_history = global_history;
end

// Train the branch predictor based on the actual branch outcome
always @(posedge clk) begin
    if (train_valid) begin
        reg [6:0] index;
        index = hash(train_pc, train_history);
        if (train_taken) begin
            // Actual branch was taken
            if (pht[index] != 2'b11) begin
                // Increment the counter
                pht[index] <= pht[index] + 1;
            end
        end else begin
            // Actual branch was not taken
            if (pht[index] != 2'b00) begin
                // Decrement the counter
                pht[index] <= pht[index] - 1;
            end
        end
    end
end

endmodule