module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Implement function for a,b = 00 (mux_in[0])
// Given cd:00->0,01->0,11->0,10->1
// Truth table: c d | out
// 0 0 | 0
// 0 1 | 0
// 1 1 | 0
// 1 0 | 1
// out = ~d & c
wire mux_in_0;
assign mux_in_0 = (~d) & c; // Using only muxes required, here we use muxes below

// Implement function for a,b = 01 (mux_in[1])
// cd:00->1,01->0,11->0,10->0
// truth table:
// 0 0 |1
// 0 1 |0
// 1 1 |0
// 1 0 |0
// This is only true when c=0 and d=0
// out = ~c & ~d

// Implement function for a,b = 11 (mux_in[3])
// cd:00->1,01->0,11->1,10->1
// 0 0 |1
// 0 1 |0
// 1 1 |1
// 1 0 |1
// out = (c & ~d) | (~c & ~d) | (c & d)
// Simplify: out=1 when d=0 or (c=1 and d=1)
// out = ~d | (c & d)

// Implement function for a,b = 10 (mux_in[2])
// cd:00->1,01->0,11->0,10->1
// 0 0 |1
// 0 1 |0
// 1 1 |0
// 1 0 |1
// out = ~d

// Since the requirement is to implement using only multiplexers,
// we express each output using 2-to-1 muxes with c or d as select, and constants 0 and 1.

// 2-to-1 mux module:
module mux2to1(
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// Now implement each mux_in[i] using mux2to1 with c or d as select and constants.

// mux_in[0] = ~d & c
// use mux with c as sel:
// if c=0 -> 0
// if c=1 -> ~d
wire not_d;
mux2to1 m0_notd(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d)); // not_d = ~d
mux2to1 m0(.sel(c), .in0(1'b0), .in1(not_d), .out(mux_in[0]));

// mux_in[1] = ~c & ~d
// implement ~c first:
wire not_c;
mux2to1 m1_notc(.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));
// now ~c & ~d using mux with not_c as sel:
// if not_c=0 -> 0
// if not_c=1 -> ~d
mux2to1 m1_notd(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d)); // reuse not_d
mux2to1 m1_and(.sel(not_c), .in0(1'b0), .in1(not_d), .out(mux_in[1]));

// mux_in[3] = ~d | (c & d)
// first c & d:
wire c_and_d;
mux2to1 m3_c_and_d(.sel(c), .in0(1'b0), .in1(d), .out(c_and_d));
// ~d:
mux2to1 m3_notd(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d)); // reuse not_d
// ~d | (c & d) = if ~d=1 then 1 else c_and_d
mux2to1 m3_or(.sel(not_d), .in0(c_and_d), .in1(1'b1), .out(mux_in[3]));

// mux_in[2] = ~d
// reuse not_d:
mux2to1 m2_notd(.sel(d), .in0(1'b1), .in1(1'b0), .out(mux_in[2]));

endmodule