module TopModule(
    input  signed [7:0] in,
    output signed [31:0] out
);

    assign out = in;  // Implicit sign-extension from 8-bit signed to 32-bit signed

endmodule