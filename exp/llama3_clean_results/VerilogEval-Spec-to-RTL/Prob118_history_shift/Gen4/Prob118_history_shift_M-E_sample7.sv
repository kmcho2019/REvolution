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
reg predicted;
reg [0:0] predicted_taken;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
        predicted <= 1'b0;
        predicted_taken <= 1'b0;
    end else begin
        if (train_mispredicted) begin
            history <= {train_history, train_taken};
            predicted <= 1'b0;
            predicted_taken <= 1'b0;
        end else if (predict_valid) begin
            predicted <= 1'b1;
            predicted_taken <= predict_taken;
            history <= {history[30:0], predict_taken};
        end else if (predicted) begin
            // do nothing
        end else begin
            // do nothing
        end
    end
end

assign predict_history = history;

endmodule