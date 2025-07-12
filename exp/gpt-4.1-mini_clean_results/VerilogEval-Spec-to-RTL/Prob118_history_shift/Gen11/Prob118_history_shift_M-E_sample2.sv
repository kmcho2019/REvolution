module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history_reg;

    integer i;

    // Assign output
    assign predict_history = history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset clears the history
            history_reg <= 32'b0;
        end else if (train_mispredicted) begin
            // Load entire history: train_history concatenated with train_taken at LSB
            // Since predict_history[0] is youngest, LSB is train_taken, then train_history[0] is next bit, etc.
            // So history_reg = {train_history, train_taken}
            history_reg <= {train_history, 1'b0} | {31'b0, train_taken};
        end else if (predict_valid) begin
            // Shift history one bit towards MSB
            // The youngest bit is at [0], shift left inserts predict_taken at LSB
            // Explicit shift by moving bits one position up
            for (i = 31; i > 0; i = i - 1) begin
                history_reg[i] <= history_reg[i-1];
            end
            history_reg[0] <= predict_taken;
        end
        // else no change
    end

endmodule