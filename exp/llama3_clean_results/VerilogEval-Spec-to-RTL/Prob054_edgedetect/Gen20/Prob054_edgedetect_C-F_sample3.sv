module EdgeDetect(
    input clk,
    input in,
    output reg pedge
);

reg prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    pedge <= in & ~prev_in;  // detect 0 to 1 transition using bitwise AND
end

endmodule

module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

// Unroll the loop to reduce the combinational path delay
EdgeDetect edge_detect_0(
   .clk(clk),
   .in(in[0]),
   .pedge(pedge[0])
);

EdgeDetect edge_detect_1(
   .clk(clk),
   .in(in[1]),
   .pedge(pedge[1])
);

EdgeDetect edge_detect_2(
   .clk(clk),
   .in(in[2]),
   .pedge(pedge[2])
);

EdgeDetect edge_detect_3(
   .clk(clk),
   .in(in[3]),
   .pedge(pedge[3])
);

EdgeDetect edge_detect_4(
   .clk(clk),
   .in(in[4]),
   .pedge(pedge[4])
);

EdgeDetect edge_detect_5(
   .clk(clk),
   .in(in[5]),
   .pedge(pedge[5])
);

EdgeDetect edge_detect_6(
   .clk(clk),
   .in(in[6]),
   .pedge(pedge[6])
);

EdgeDetect edge_detect_7(
   .clk(clk),
   .in(in[7]),
   .pedge(pedge[7])
);

endmodule