module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Explicitly replicate the sign bit 24 times and concatenate with 'in'
    assign out = { {24{in[7]}}, in };

endmodule