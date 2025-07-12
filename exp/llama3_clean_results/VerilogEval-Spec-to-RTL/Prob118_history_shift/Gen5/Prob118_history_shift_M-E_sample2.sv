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
reg [1:0] state; // idle (0), predict (1), mispredict (2)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
        state <= 2'd0; // idle
    end else begin
        case (state)
            2'd0: begin // idle
                if (predict_valid) begin
                    state <= 2'd1; // predict
                    history <= {history[30:0], predict_taken};
                end else if (train_mispredicted) begin
                    state <= 2'd2; // mispredict
                    history <= {train_history, train_taken};
                end
            end
            2'd1: begin // predict
                if (train_mispredicted) begin
                    state <= 2'd2; // mispredict
                    history <= {train_history, train_taken};
                end else begin
                    state <= 2'd0; // idle
                end
            end
            2'd2: begin // mispredict
                state <= 2'd0; // idle
            end
        endcase
    end
end

assign predict_history = history;

endmodule