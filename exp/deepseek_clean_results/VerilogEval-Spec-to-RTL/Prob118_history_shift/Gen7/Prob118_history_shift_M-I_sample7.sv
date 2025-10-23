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
    wire reg_enable = areset | train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (reg_enable) begin
            if (train_mispredicted) begin
                // Split into two segments for better synthesis
                history_reg <= {train_history[30:16], train_history[15:0], train_taken};
            end else begin // predict_valid must be true
                history_reg <= {history_reg[30:16], history_reg[15:0], predict_taken};
            end
        end
    end

    assign predict_history = history_reg;

endmodule