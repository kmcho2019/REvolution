module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

reg [31:0] history;

// Module for handling branch predictions
module PredictModule(
    input predict_valid,
    input predict_taken,
    input [31:0] history,
    output [31:0] next_history
);
    assign next_history = (predict_valid)? {history[30:0], predict_taken} : history;
endmodule

// Module for handling mispredictions
module MispredictModule(
    input train_mispredicted,
    input [31:0] train_history,
    input train_taken,
    input [31:0] history,
    output [31:0] next_history
);
    assign next_history = (train_mispredicted)? {train_history, train_taken} : history;
endmodule

// Instantiation of the modules
PredictModule predict_module(predict_valid, predict_taken, history, next_history_predict);
MispredictModule mispredict_module(train_mispredicted, train_history, train_taken, history, next_history_mispredict);

// Logic to select between prediction and misprediction update
wire [31:0] next_history = (train_mispredicted)? next_history_mispredict : next_history_predict;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
    end else begin
        history <= next_history;
    end
end

assign predict_history = history;

endmodule