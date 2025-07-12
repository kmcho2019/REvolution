// Top-level module
module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// Instantiate predictor module
Predictor predictor(
  .clk(clk),
  .areset(areset),
  .predict_valid(predict_valid),
  .predict_pc(predict_pc),
  .predict_taken(predict_taken),
  .predict_history(predict_history),
  .train_valid(train_valid),
  .train_taken(train_taken),
  .train_mispredicted(train_mispredicted),
  .train_history(train_history),
  .train_pc(train_pc)
);

endmodule

// Predictor module
module Predictor(
    input clk,
    input areset,
    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// Global history register
reg [6:0] global_history;

// Cache structure to store recent branch outcomes and their corresponding histories
reg [1:0] cache_outcome [127:0];

// Index to access cache
reg [6:0] cache_index;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Initialize cache and histories
        for (int i = 0; i < 128; i++) begin
            cache_outcome[i] <= 2'b0;
        end
        global_history <= 7'b0;
    end else if (predict_valid) begin
        // Calculate index using XOR operation
        cache_index <= predict_pc ^ global_history;
        // Check cache for a matching entry
        if (cache_outcome[cache_index] == 2'b11) begin
            // Strongly taken
            predict_taken <= 1'b1;
        end else if (cache_outcome[cache_index] == 2'b10) begin
            // Weakly taken
            predict_taken <= 1'b1;
        end else if (cache_outcome[cache_index] == 2'b01) begin
            // Weakly not taken
            predict_taken <= 1'b0;
        end else begin
            // Strongly not taken
            predict_taken <= 1'b0;
        end
        predict_history <= global_history;
        // Update global history
        if (predict_taken) begin
            global_history <= {global_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
        end
    end else if (train_valid) begin
        // Update cache with new branch outcome and its corresponding history
        cache_index <= train_pc ^ train_history;
        if (train_taken) begin
            if (cache_outcome[cache_index] == 2'b00) begin
                cache_outcome[cache_index] <= 2'b01;
            end else if (cache_outcome[cache_index] == 2'b01) begin
                cache_outcome[cache_index] <= 2'b11;
            end
        end else begin
            if (cache_outcome[cache_index] == 2'b11) begin
                cache_outcome[cache_index] <= 2'b10;
            end else if (cache_outcome[cache_index] == 2'b10) begin
                cache_outcome[cache_index] <= 2'b00;
            end
        end
        // Update global history if mispredicted
        if (train_mispredicted) begin
            global_history <= train_history;
        end
    end
end

endmodule