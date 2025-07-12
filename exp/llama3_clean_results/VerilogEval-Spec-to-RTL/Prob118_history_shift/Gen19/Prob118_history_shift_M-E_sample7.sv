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

// Internal signals
reg [31:0] shifted_history;
reg [31:0] history;

// Barrel Shifter for prediction update
always @(posedge clk) begin
    if (predict_valid) begin
        shifted_history <= {history[30:0], predict_taken};
    end else begin
        shifted_history <= history;
    end
end

// Pipeline Register for misprediction handling
always @(posedge clk) begin
    if (train_mispredicted) begin
        history <= {train_history, train_taken};
    end else if (predict_valid) begin
        history <= shifted_history;
    end else begin
        history <= history;
    end
end

// Asynchronous reset
always @(posedge areset) begin
    history <= 32'd0;
end

assign predict_history = history;

endmodule