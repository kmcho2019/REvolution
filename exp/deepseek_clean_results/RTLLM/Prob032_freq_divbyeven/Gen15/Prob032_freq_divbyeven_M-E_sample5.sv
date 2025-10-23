module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number
localparam SHIFT_WIDTH = NUM_DIV / 2;

reg [SHIFT_WIDTH-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= {1'b1, {(SHIFT_WIDTH-1){1'b0}}};
        clk_div <= 1'b0;
    end else begin
        // Circular right shift
        shift_reg <= {shift_reg[0], shift_reg[SHIFT_WIDTH-1:1]};
        clk_div <= shift_reg[SHIFT_WIDTH-1];
    end
end

endmodule