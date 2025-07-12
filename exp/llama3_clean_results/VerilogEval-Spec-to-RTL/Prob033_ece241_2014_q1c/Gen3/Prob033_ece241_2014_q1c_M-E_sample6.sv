module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

assign s = a + b;
assign overflow = ($signed(s) > 127 || $signed(s) < -128);

endmodule