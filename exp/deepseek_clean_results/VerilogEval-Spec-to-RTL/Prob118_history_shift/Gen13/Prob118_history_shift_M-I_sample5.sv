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
    wire reg_enable = areset || train_mispredicted || predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (reg_enable) begin
            if (train_mispredicted) begin
                // Rollback to correct history: train_history + actual taken
                history_reg <= {train_history[30:0], train_taken};
            end else begin
                // Shift in new prediction (optimized implementation)
                history_reg <= {history_reg[30:0], predict_taken};
            end
        end
    end

    assign predict_history = history_reg;

endmodule