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

    // Asynchronous reset with synchronous logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load history with train_taken concatenated with train_history[31:1]
            predict_history <= {train_taken, train_history[31:1]};
        end else if (predict_valid) begin
            // Shift in predict_taken at LSB
            predict_history <= {predict_history[31:1], predict_taken};
        end
    end

endmodule