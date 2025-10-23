module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Simplified population count for 3-bit input
    assign out = {|(in[2:1] & in[1:0]), ^in};  // MSB: majority, LSB: parity
endmodule