module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [3:0] mux_out;

// Create a 4-to-1 multiplexer
mux4to1 mux0 (
    .i0(b),    // input 0
    .i1(e),    // input 1
    .i2(a),    // input 2
    .i3(d),    // input 3
    .s(c[1:0]),  // select lines
    .out(mux_out)  // output
);

// Assign the output of the MUX to q
assign q = (c < 4) ? mux_out : 4'b1111;  // 'f' is represented as 4'b1111

endmodule

// Define the 4-to-1 multiplexer module
module mux4to1(
    input  [3:0] i0,
    input  [3:0] i1,
    input  [3:0] i2,
    input  [3:0] i3,
    input  [1:0] s,
    output [3:0] out
);

wire [3:0] out0, out1, out2, out3;

assign out0 = (s == 2'b00) ? i0 : 4'b0000;
assign out1 = (s == 2'b01) ? i1 : 4'b0000;
assign out2 = (s == 2'b10) ? i2 : 4'b0000;
assign out3 = (s == 2'b11) ? i3 : 4'b0000;

assign out = out0 | out1 | out2 | out3;

endmodule