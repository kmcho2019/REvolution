module TopModule (
    input        clk,
    input        areset,
    input        predict_valid,
    input        predict_taken,
    input        train_mispredicted,
    input        train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    // Asynchronous reset with synchronous updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load history after mispredicted branch: {train_history[31:1], train_taken}
            // train_history[31:0], but we want bits [31:1] of train_history as upper 31 bits
            predict_history <= {train_history[31:1], train_taken};
        end else if (predict_valid) begin
            // Shift left by 1 and insert predict_taken at LSB
            predict_history <= {predict_history[30:0], predict_taken};
        end
        // else retain predict_history
    end

endmodule