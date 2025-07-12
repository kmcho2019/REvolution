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

// Define the pattern history table (PHT) as a 128-entry table of two-bit saturating counters
reg [1:0] pht [127:0];

// Define the global branch history register
reg [6:0] ghr;

// Define the predicted branch direction
reg predict_taken_reg;

// Define the index for accessing the PHT
reg [6:0] index;

// Calculate the index by hashing the global branch history and PC using XOR
always @(*) begin
    index = predict_pc ^ ghr;
end

// Update the PHT and recover the branch history register if a misprediction occurs
always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 0;
        end
    end else begin
        if (train_valid) begin
            // Update the PHT
            if (train_taken) begin
                if (pht[train_pc ^ train_history] != 3) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1;
                end
            end else begin
                if (pht[train_pc ^ train_history] != 0) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1;
                end
            end

            // Recover the branch history register if a misprediction occurs
            if (train_mispredicted) begin
                ghr <= train_history;
            end else begin
                ghr <= {ghr[5:0], train_taken};
            end
        end else if (predict_valid) begin
            ghr <= {ghr[5:0], predict_taken_reg};
        end
    end
end

// Generate the predicted branch direction
always @(*) begin
    if (pht[index] >= 2) begin
        predict_taken_reg = 1;
    end else begin
        predict_taken_reg = 0;
    end
end

// Assign the outputs
assign predict_taken = predict_taken_reg;
assign predict_history = ghr;

endmodule