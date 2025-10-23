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

always @(posedge areset) 
    history <= 0;

always @(posedge clk) 
    if (train_mispredicted) history <= {train_history, train_taken};
    else if (predict_valid) history <= {history[30:0], predict_taken};

assign predict_history = history;

endmodule