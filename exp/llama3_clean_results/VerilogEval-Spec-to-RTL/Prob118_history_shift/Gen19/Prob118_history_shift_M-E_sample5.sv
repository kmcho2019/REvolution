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
reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'd0;
        history <= 32'd0;
    end else begin
        case (state)
            2'd0: // Idle state
                begin
                    if (train_mispredicted) begin
                        state <= 2'd2;
                    end else if (predict_valid) begin
                        state <= 2'd1;
                    end
                end
            2'd1: // Predict state
                begin
                    history <= {history[30:0], predict_taken};
                    state <= 2'd0;
                end
            2'd2: // Train state
                begin
                    history <= {train_history, train_taken};
                    state <= 2'd0;
                end
            default:
                state <= 2'd0;
        endcase
    end
end

assign predict_history = history;

endmodule