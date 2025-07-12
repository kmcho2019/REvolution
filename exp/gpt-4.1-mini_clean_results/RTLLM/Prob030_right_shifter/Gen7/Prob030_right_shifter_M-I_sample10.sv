module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'b0;

wire ce = (d != q[7]);

always @(posedge clk) begin
    if (ce)
        q <= {d, q[7:1]};
end

endmodule