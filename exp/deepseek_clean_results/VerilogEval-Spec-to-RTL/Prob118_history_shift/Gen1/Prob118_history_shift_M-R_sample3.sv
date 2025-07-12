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

    // Reset handling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end
    end

    // Normal operation (reset has priority)
    always @(posedge clk) begin
        if (!areset) begin
            history_reg <= train_mispredicted ? {train_history[30:0], train_taken} :
                        predict_valid ? {history_reg[30:0], predict_taken} :
                        history_reg;
        end
    end

    assign predict_history = history_reg;

endmodule