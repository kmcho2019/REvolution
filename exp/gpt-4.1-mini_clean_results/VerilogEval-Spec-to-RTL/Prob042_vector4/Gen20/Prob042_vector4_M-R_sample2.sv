module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    wire signed [7:0] signed_in = in;  // Interpret input as signed
    wire signed [31:0] extended = signed_in;  // Implicit sign-extension

    assign out = extended;  // Assign sign-extended value to output

endmodule