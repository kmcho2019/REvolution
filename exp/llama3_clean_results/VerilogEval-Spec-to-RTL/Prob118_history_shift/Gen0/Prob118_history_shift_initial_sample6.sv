module TopModule(
    input            clk,
    input            areset,
    input            predict_valid,
    input            predict_taken,
    input            train_mispredicted,
    input            train_taken,
    input [31:0]     train_history,
    output [31:0]    predict_history
);

reg [31:0] history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
    end else begin
        if (train_mispredicted) begin
            history <= {train_history, train_taken};
        end else if (predict_valid) begin
            history <= {history[30:0], predict_taken};
        end
    end
end

assign predict_history = history;

endmodule