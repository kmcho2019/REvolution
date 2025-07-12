module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    // Declare signed versions of input and output
    wire signed [7:0]  in_signed = in;
    wire signed [31:0] out_signed;

    // Assign the signed extended value automatically
    assign out_signed = in_signed;
    assign out = out_signed;

endmodule