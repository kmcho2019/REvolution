module TopModule (
    input wire c,
    input wire d,
    output wire [3:0] mux_in
);

// Define a 2-to-1 mux module for clarity and reuse
module mux2to1 (
    input wire sel,
    input wire in0,
    input wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

// Implement NOT d using 2-to-1 mux:
// NOT d = mux with sel=d, in0=1, in1=0
wire not_d;
mux2to1 not_gate (
    .sel(d),
    .in0(1'b1),
    .in1(1'b0),
    .out(not_d)
);

// Implement mux_in[0] for ab=00:
// K-map cd inputs: 00->0,01->1,11->1,10->1
// cd= c d
// Truth table:
// c d | out
// 0 0 |0
// 0 1 |1
// 1 0 |1
// 1 1 |1
// Using only 2-to-1 muxes controlled by c or d:

// Step 1: Mux controlled by d to select between 0 and 1:
// For c=0:
//   d=0 -> 0
//   d=1 -> 1
// For c=1:
// Output always 1

wire mux0_d_mux;
mux2to1 mux0_d (
    .sel(d),
    .in0(1'b0),
    .in1(1'b1),
    .out(mux0_d_mux)
);

// Step 2: Mux controlled by c to select between mux0_d_mux and 1:
mux2to1 mux0_c (
    .sel(c),
    .in0(mux0_d_mux),
    .in1(1'b1),
    .out(mux_in[0])
);

// Implement mux_in[1] for ab=01:
// All zeros per K-map
assign mux_in[1] = 1'b0;

// Implement mux_in[2] for ab=11:
// K-map:
// 00->0,01->0,10->0,11->1
// Output= c & d

// Using only 2-to-1 muxes:

// Step 1: Mux controlled by d:
// if d=0 out=0
// if d=1 out=c
wire mux2_d_mux;
mux2to1 mux2_d (
    .sel(d),
    .in0(1'b0),
    .in1(c),
    .out(mux_in[2])
);

// Implement mux_in[3] for ab=10:
// K-map:
// cd: 00->1,01->0,10->1,11->1
// Truth table:
// c d | out
// 0 0 |1
// 0 1 |0
// 1 0 |1
// 1 1 |1

// Expression: out = c + (~c & ~d)

// Implement NOT d already as not_d

// Step 1: Mux controlled by d, in0=1, in1=0:
wire d_mux;
mux2to1 d_mux_gate (
    .sel(d),
    .in0(1'b1),
    .in1(1'b0),
    .out(d_mux)
);

// Step 2: Mux controlled by c, in0=d_mux, in1=1:
mux2to1 mux3_c (
    .sel(c),
    .in0(d_mux),
    .in1(1'b1),
    .out(mux_in[3])
);

endmodule