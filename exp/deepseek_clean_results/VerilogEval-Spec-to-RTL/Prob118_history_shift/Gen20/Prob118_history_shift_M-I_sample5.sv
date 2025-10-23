module TopModule (
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
    reg [31:0] next_history;
    wire prediction_update = predict_valid & ~train_mispredicted;
    wire [31:0] mispred_update = {train_history[30:0], train_taken};
    wire [31:0] pred_update = {history[30:0], predict_taken};

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else begin
            history <= next_history;
        end
    end

    always @(*) begin
        casez ({areset, train_mispredicted, prediction_update})
            3'b1??: next_history = 32'b0;
            3'b01?: next_history = mispred_update;
            3'b001: next_history = pred_update;
            default: next_history = history;
        endcase
    end

    assign predict_history = history;

endmodule