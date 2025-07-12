module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Interpret 'in' as signed 8-bit number
    wire signed [7:0] signed_in = in;

    // Signed assignment automatically sign-extends to 32 bits
    wire signed [31:0] signed_extended = signed_in;

    // Assign to unsigned output
    assign out = signed_extended;

endmodule