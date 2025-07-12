module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    // This line sign-extends the 8-bit input number to 32 bits by replicating the sign bit 24 times
    // and then concatenating it with the original 8-bit number.
    assign out = { {24{in[7]}}, in};

endmodule