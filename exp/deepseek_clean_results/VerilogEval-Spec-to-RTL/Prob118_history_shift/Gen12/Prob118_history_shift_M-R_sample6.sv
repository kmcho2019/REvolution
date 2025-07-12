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

    reg [31:0] history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction, load history and append actual taken
            history_reg <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // On prediction, shift in new prediction
            history_reg <= {history_reg[30:0], predict_taken};
        end
    end

    // Output is always the current history register
    assign predict_history = history_reg;

endmodule