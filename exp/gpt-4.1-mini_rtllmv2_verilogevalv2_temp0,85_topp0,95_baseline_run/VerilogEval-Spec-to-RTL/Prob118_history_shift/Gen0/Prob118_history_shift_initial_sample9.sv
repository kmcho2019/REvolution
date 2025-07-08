module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:1] train_history, // Note: train_history is 32 bits, but per spec bits 31:1 used to concatenate with train_taken
    output reg [31:0] predict_history
);

    // Asynchronous reset and synchronous update of the history register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load the history before the mispredicted branch concatenated with the actual branch result
            predict_history <= {train_history, train_taken};
        end else if (predict_valid) begin
            // Shift in predict_taken at LSB (youngest branch at predict_history[0])
            // Shift left by 1 bit and insert predict_taken at LSB
            predict_history <= {predict_history[30:0], predict_taken};
        end
        // else no change
    end

endmodule