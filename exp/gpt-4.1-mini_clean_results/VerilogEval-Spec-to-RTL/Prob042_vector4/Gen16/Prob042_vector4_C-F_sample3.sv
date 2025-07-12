module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Interpret input as signed 8-bit for clarity and synthesis friendliness
    wire signed [7:0] in_signed = in;

    // Explicitly replicate the sign bit (in_signed[7]) 24 times and concatenate with input
    // This combines the explicit replication operator with signed semantics
    assign out = { {24{in_signed[7]}}, in_signed };

endmodule