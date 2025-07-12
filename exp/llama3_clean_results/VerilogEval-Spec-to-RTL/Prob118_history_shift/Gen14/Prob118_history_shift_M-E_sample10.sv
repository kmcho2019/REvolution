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
reg [1:0] state; // 0: idle, 1: predict, 2: train

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        history <= 32'd0;
    end else begin
        case (state)
            0: begin // idle
                if (predict_valid) begin
                    state <= 1;
                    history <= {history[30:0], predict_taken};
                end else if (train_mispredicted) begin
                    state <= 2;
                    history <= {train_history, train_taken};
                end
            end
            1: begin // predict
                state <= 0;
            end
            2: begin // train
                state <= 0;
            end
        endcase
    end
end

assign predict_history = history;

endmodule