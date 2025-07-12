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

// Pattern history table (PHT)
reg [1:0] pht [127:0];

// Index to access PHT
reg [6:0] index;

// Confidence level for each entry in PHT
reg [1:0] confidence [127:0];

// Stage 1: History update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
    end else if (predict_valid) begin
        if (predict_taken) begin
            global_history <= {global_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
        end
    end else if (train_valid && train_mispredicted) begin
        global_history <= train_history;
    end
end

// Stage 2: Index calculation
always @(posedge clk) begin
    index <= predict_pc[6:0] ^ global_history[6:0];
end

// Stage 3: Prediction
always @(posedge clk) begin
    if (predict_valid) begin
        predict_taken <= (pht[index] >= 2'b10);
        predict_history <= global_history;
    end
end

// Training interface
always @(posedge clk) begin
    if (train_valid) begin
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht[index] <= pht[index] + 1'b1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                pht[index] <= pht[index] - 1'b1;
            end
        end
        if (train_mispredicted) begin
            global_history <= train_history;
        end
    end
end

// Confidence-based mechanism
always @(posedge clk) begin
    if (predict_valid) begin
        if (predict_taken == (pht[index] >= 2'b10)) begin
            confidence[index] <= confidence[index] + 1'b1;
        end else begin
            confidence[index] <= confidence[index] - 1'b1;
        end
    end
end

endmodule