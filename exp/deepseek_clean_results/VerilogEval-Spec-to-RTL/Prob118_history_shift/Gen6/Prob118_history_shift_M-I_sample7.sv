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
    wire clk_gated = clk & (predict_valid | train_mispredicted | areset);

    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            // Misprediction has priority
            if (train_mispredicted) begin
                history_reg <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                history_reg <= {history_reg[30:0], predict_taken};
            end
        end
    end

    assign predict_history = history_reg;

endmodule