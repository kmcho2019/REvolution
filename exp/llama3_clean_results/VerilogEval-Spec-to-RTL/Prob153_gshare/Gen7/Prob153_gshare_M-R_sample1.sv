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

// Cache structure to store recent branch outcomes
reg [1:0] cache [127:0];

// Cache index calculation
assign predict_index = predict_pc ^ global_history;
assign train_index = train_pc ^ train_history;

// Prediction logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
    end else if (predict_valid) begin
        predict_taken <= (cache[predict_index] == 2'b11 || cache[predict_index] == 2'b10);
        predict_history <= global_history;
    end
end

// Training logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            cache[i] <= 2'b00;
        end
    end else if (train_valid) begin
        if (train_taken) begin
            if (cache[train_index] == 2'b00) begin
                cache[train_index] <= 2'b01;
            end else if (cache[train_index] == 2'b01) begin
                cache[train_index] <= 2'b11;
            end
        end else begin
            if (cache[train_index] == 2'b11) begin
                cache[train_index] <= 2'b10;
            end else if (cache[train_index] == 2'b10) begin
                cache[train_index] <= 2'b00;
            end
        end
        if (train_mispredicted) begin
            global_history <= train_history;
        end
    end else if (predict_valid) begin
        if (predict_taken) begin
            global_history <= {global_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
        end
    end
end

endmodule