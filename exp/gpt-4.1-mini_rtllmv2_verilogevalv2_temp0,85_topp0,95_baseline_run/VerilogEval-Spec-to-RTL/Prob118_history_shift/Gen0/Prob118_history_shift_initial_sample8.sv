module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history;

    // Asynchronous reset triggered on positive edge of areset
    // Positive edge triggered sequential logic on clk
    // Combine areset and clk using always block with posedge clk or posedge areset

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Load rollback history: train_history concatenated with train_taken
                // train_history is older bits, train_taken is the newest branch
                history <= {train_taken, train_history[31:1]};
                // Wait, this would take train_taken as MSB but the spec says:
                // "load the branch history register with the history after the completion of the mispredicted branch. This is the history before the mispredicted branch (train_history) concatenated with the actual result of the branch (train_taken)."
                // predict_history[0] is youngest branch, so LSB is youngest.
                // The shift register places youngest branch at bit 0.
                // So the concatenation should be train_taken at LSB, train_history shifted left by 1.
                // So history = {train_history[30:0], train_taken}
                history <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Shift in predict_taken into LSB, older bits shift left
                history <= {history[30:0], predict_taken};
            end
            // else hold history
        end
    end

    assign predict_history = history;

endmodule