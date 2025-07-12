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
    wire update_en = areset | train_mispredicted | predict_valid;
    wire clk_gated = clk & update_en;

    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (train_mispredicted) begin
            history_reg <= {train_history[30:0], train_taken};
        end else begin // predict_valid implied by clock gating
            history_reg <= {history_reg[30:0], predict_taken};
        end
    end

    assign predict_history = history_reg;

endmodule