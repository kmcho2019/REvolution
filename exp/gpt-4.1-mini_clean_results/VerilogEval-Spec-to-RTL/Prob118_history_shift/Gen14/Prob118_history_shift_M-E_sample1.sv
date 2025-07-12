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

    assign predict_history = history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction, load corrected history with train_taken as LSB
            // train_history has older branches MSB side, so concat train_taken at LSB
            history_reg <= {train_history[31:1], train_taken, 1'b0} >> 1; 
            // The above looks complicated, better just:
            history_reg <= {train_history, train_taken};
        end else if (predict_valid) begin
            // On prediction, shift left by 1 (old MSB dropped), insert predict_taken at LSB
            history_reg <= {history_reg[30:0], predict_taken};
        end
        // else hold state
    end

endmodule