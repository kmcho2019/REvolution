module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [3:0] mux_out;

// Create a 5-to-1 multiplexer
mux5to1 mux0 (
    .i0(b),    // input 0
    .i1(e),    // input 1
    .i2(a),    // input 2
    .i3(d),    // input 3
    .i4(4'b1111),    // input 4 (constant 'f')
    .s(c[1:0]),  // select lines (only 2 bits are needed for 0-3)
    .out(mux_out)  // output
);

// Use a case statement to select the output
always @(*)
begin
    case (c[1:0])
        2'b00: q = mux_out;  // c = 0
        2'b01: q = mux_out;  // c = 1
        2'b10: q = mux_out;  // c = 2
        2'b11: q = mux_out;  // c = 3
        default: q = 4'b1111;  // c = 4 or greater
    endcase
end

endmodule

// Define the 5-to-1 multiplexer module
module mux5to1(
    input  [3:0] i0,
    input  [3:0] i1,
    input  [3:0] i2,
    input  [3:0] i3,
    input  [3:0] i4,
    input  [1:0] s,
    output [3:0] out
);

wire [3:0] out0, out1, out2, out3, out4;

assign out0 = (s == 2'b00) ? i0 : 4'b0000;
assign out1 = (s == 2'b01) ? i1 : 4'b0000;
assign out2 = (s == 2'b10) ? i2 : 4'b0000;
assign out3 = (s == 2'b11) ? i3 : 4'b0000;
assign out4 = (s == 2'b00 && c >= 4) ? i4 : 4'b0000;

assign out = out0 | out1 | out2 | out3 | out4;

endmodule