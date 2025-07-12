module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

reg d_reg;

always @(posedge clk) begin
    d_reg <= d;          // Register input to improve timing
    q <= {d_reg, q[7:1]}; // Right shift with registered input
end

endmodule