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

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction rollback: newest bit = train_taken (LSB), rest from train_history[31:1]
            predict_history <= {train_history[31:1], train_taken};
        end else if (predict_valid) begin
            // Shift in predicted bit at LSB; shift older bits up by one
            predict_history <= {predict_history[30:0], predict_taken};
        end
        // else retain previous predict_history to avoid unnecessary toggling
    end

endmodule