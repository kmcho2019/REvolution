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

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction, load the concatenated history: {train_history[30:0], train_taken}
            history_reg <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // On prediction, shift left by one and shift in predict_taken at LSB
            history_reg <= {history_reg[30:0], predict_taken};
        end
        // else hold current history
    end

    assign predict_history = history_reg;

endmodule