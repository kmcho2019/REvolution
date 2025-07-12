module TopModule(
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
reg         predict_update;
reg         train_update;
reg         clock_enable;

// Prediction Block
always @(posedge clk) begin
    if (predict_valid) begin
        predict_update <= 1'b1;
    end else begin
        predict_update <= 1'b0;
    end
end

// Training Block
always @(posedge clk) begin
    if (train_mispredicted) begin
        train_update <= 1'b1;
    end else begin
        train_update <= 1'b0;
    end
end

// History Update Controller
always @(posedge clk) begin
    if (train_update) begin
        clock_enable <= 1'b1;
    end else if (predict_update) begin
        clock_enable <= 1'b1;
    end else begin
        clock_enable <= 1'b0;
    end
end

// History Register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
    end else if (clock_enable) begin
        if (train_update) begin
            history <= {train_history, train_taken};
        end else if (predict_update) begin
            history <= {history[30:0], predict_taken};
        end
    end
end

assign predict_history = history;

endmodule