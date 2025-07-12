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

wire [31:0] next_history;

// Break down the concatenation operation into smaller parts
wire [30:0] shifted_history;
assign shifted_history = history[30:0];

assign next_history = (train_mispredicted) ? {train_history, train_taken} :
                       (predict_valid) ? {shifted_history, predict_taken} :
                       history;

// Add a clock gate to disable the combinational logic when the next_history signal is not changing
reg enable;
always @(posedge clk) begin
    if (next_history == history) begin
        enable <= 0;
    end else begin
        enable <= 1;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
    end else if (enable) begin
        history <= next_history;
    end
end

assign predict_history = history;

endmodule