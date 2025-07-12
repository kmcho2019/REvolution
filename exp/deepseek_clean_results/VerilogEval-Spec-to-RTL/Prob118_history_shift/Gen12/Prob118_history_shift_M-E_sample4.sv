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
    reg [31:0] shadow_reg;  // Stores state before prediction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
            shadow_reg <= 32'b0;
        end else begin
            // Update shadow register on valid predictions
            if (predict_valid) begin
                shadow_reg <= history_reg;
            end

            // Priority: misprediction > prediction
            if (train_mispredicted) begin
                history_reg <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                history_reg <= {history_reg[30:0], predict_taken};
            end
        end
    end

    assign predict_history = history_reg;

endmodule