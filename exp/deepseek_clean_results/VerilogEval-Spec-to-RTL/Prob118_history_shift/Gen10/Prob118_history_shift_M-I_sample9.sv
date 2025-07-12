module TopModule #(
    parameter WIDTH = 32
) (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [WIDTH-1:0] train_history,
    output [WIDTH-1:0] predict_history
);

    reg [WIDTH-1:0] history_reg;
    wire clk_enable = areset || train_mispredicted || predict_valid;
    wire gated_clk = clk_enable ? clk : 1'b0;

    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            history_reg <= {WIDTH{1'b0}};
        end else if (train_mispredicted) begin
            // Split 32-bit shift into two 16-bit operations
            history_reg[15:0] <= {train_history[14:0], train_taken};
            history_reg[31:16] <= train_history[30:15];
        end else if (predict_valid) begin
            // Split 32-bit shift into two 16-bit operations
            history_reg[15:0] <= {history_reg[14:0], predict_taken};
            history_reg[31:16] <= history_reg[30:15];
        end
    end

    assign predict_history = history_reg;

endmodule