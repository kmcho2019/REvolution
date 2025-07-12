module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

always @(posedge clk)
    if (reset) q <= 4'd0;
    else q <= {q[2:0], q[3] ^ (q[3] & q[2])};

endmodule