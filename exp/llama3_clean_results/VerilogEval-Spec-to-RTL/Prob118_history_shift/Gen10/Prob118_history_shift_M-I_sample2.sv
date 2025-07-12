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
reg [31:0] next_history;

wire [31:0] predict_next_history = {history[30:0], predict_taken};
wire [:0] train_next_history = {train_history, train_taken};

assign next_history = (train_mispredicted) ? train_next_history[:0] :
                       (predict_valid) ? predict_next_history :
                       history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
    end else begin
        history <= next_history;
    end
end

assign predict_history = history;

endmodule