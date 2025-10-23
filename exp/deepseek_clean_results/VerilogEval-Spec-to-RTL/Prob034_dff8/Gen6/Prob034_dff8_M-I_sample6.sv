module TopModule #(
    parameter USE_RESET = 0
) (
    input        clk,
    input  [7:0] d,
    output [7:0] q,
    input        rst_n = 1'b1  // Optional reset (active low)
);

reg [7:0] q_reg;

always @(posedge clk) begin
    if (USE_RESET && !rst_n)
        q_reg <= 8'h0;
    else
        q_reg <= d;
end

assign q = q_reg;

endmodule