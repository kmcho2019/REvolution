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

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
    end else begin
        case (1'b1)
            train_mispredicted: history <= {train_history, train_taken};
            predict_valid: history <= {history[30:0], predict_taken};
            default: history <= history;
        endcase
    end
end

assign predict_history = history;

endmodule