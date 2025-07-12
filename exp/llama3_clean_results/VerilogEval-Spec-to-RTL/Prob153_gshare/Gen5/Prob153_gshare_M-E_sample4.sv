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

// Content-addressable memory (CAM) to store branch outcomes and their corresponding histories
reg [1:0] cam_outcome [127:0];
reg [6:0] cam_history [127:0];
reg [6:0] global_history;

// Index to access CAM
reg [6:0] cam_index;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Initialize CAM and histories
        for (int i = 0; i < 128; i++) begin
            cam_outcome[i] <= 2'b0;
            cam_history[i] <= 7'b0;
        end
        global_history <= 7'b0;
    end else if (predict_valid) begin
        // Calculate index to access CAM
        cam_index <= predict_pc ^ global_history;
        // Check CAM for matching entry
        for (int i = 0; i < 128; i++) begin
            if (cam_history[i] == global_history) begin
                // Use CAM outcome as prediction
                predict_taken <= cam_outcome[i][1];
                predict_history <= cam_history[i];
            end
        end
        // Update global history
        if (predict_taken) begin
            global_history <= {global_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
        end
    end else if (train_valid) begin
        // Update CAM with new branch outcome and its corresponding history
        cam_outcome[cam_index] <= train_taken ? 2'b11 : 2'b00;
        cam_history[cam_index] <= train_history;
        // Update global history
        if (train_mispredicted) begin
            global_history <= train_history;
        end
    end
end

endmodule