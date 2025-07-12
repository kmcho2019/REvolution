module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    if (d != q[7])  // clock enable: only update if new input bit differs from MSB
        q <= {d, q[7:1]};
end

endmodule