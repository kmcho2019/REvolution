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

// Cache structure to store recent branch outcomes and their corresponding histories
reg [6:0] cache_global_history [7:0];
reg [6:0] cache_local_history [7:0];
reg [1:0] cache_outcome [7:0];
reg [2:0] cache_confidence [7:0];

// Global history register
reg [6:0] global_history;

// Local history register
reg [6:0] local_history;

// Index to access cache
reg [2:0] cache_index;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Initialize cache and histories
        for (int i = 0; i < 8; i++) begin
            cache_global_history[i] <= 7'b0;
            cache_local_history[i] <= 7'b0;
            cache_outcome[i] <= 2'b0;
            cache_confidence[i] <= 3'b0;
        end
        global_history <= 7'b0;
        local_history <= 7'b0;
        cache_index <= 3'b0;
    end else if (predict_valid) begin
        // Check cache for matching global or local history
        if (cache_global_history[cache_index] == predict_pc) begin
            // Use cached outcome as prediction
            predict_taken <= cache_outcome[cache_index];
            predict_history <= cache_global_history[cache_index];
        end else if (cache_local_history[cache_index] == predict_pc) begin
            // Use cached outcome as prediction
            predict_taken <= cache_outcome[cache_index];
            predict_history <= cache_local_history[cache_index];
        end else begin
            // Use global history to make prediction
            predict_taken <= global_history[6];
            predict_history <= global_history;
        end
        // Update cache with new branch outcome and its corresponding history
        cache_global_history[cache_index] <= predict_pc;
        cache_local_history[cache_index] <= predict_pc;
        cache_outcome[cache_index] <= predict_taken;
        cache_confidence[cache_index] <= 3'b1;
        // Update global and local histories
        if (predict_taken) begin
            global_history <= {global_history[5:0], 1'b1};
            local_history <= {local_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
            local_history <= {local_history[5:0], 1'b0};
        end
    end else if (train_valid) begin
        // Update cache with new branch outcome and its corresponding history
        cache_global_history[cache_index] <= train_pc;
        cache_local_history[cache_index] <= train_pc;
        cache_outcome[cache_index] <= train_taken;
        cache_confidence[cache_index] <= 3'b1;
        // Update global and local histories
        if (train_mispredicted) begin
            global_history <= train_history;
            local_history <= train_history;
        end
    end
end

endmodule