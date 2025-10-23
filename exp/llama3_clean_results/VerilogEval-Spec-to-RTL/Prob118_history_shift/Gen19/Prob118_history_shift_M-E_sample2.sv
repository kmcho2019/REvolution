module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [31:0] history;

wire [31:0] predict_new_history = {history[30:0], predict_taken};
wire [31:0] train_new_history = {train_history, train_taken};

wire [31:0] new_history = (train_mispredicted ? train_new_history : (predict_valid ? predict_new_history : history));

always @(posedge clk or posedge areset) 
    if (areset) history <= 0; 
    else history <= new_history;

assign predict_history = history;

endmodule