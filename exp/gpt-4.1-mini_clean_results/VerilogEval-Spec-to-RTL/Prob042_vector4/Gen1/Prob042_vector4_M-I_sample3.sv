module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Interpret input as signed 8-bit, then assign to 32-bit output (unsigned)
    assign out = $signed(in);
endmodule