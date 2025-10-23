module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    wire [31:0] rollback_history = {train_history[30:0], train_taken};
    wire [31:0] shift_history    = {predict_history[30:0], predict_taken};
    wire [31:0] next_history;

    assign next_history = areset ? 32'b0 :
                          train_mispredicted ? rollback_history :
                          (predict_valid ? shift_history : predict_history);

    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else
            predict_history <= next_history;
    end

endmodule