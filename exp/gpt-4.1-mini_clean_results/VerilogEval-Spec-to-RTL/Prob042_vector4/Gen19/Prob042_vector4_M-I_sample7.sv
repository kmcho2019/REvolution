module TopModule (
    input  [7:0] in,
    output signed [31:0] out
);

    // Cast input to signed and assign directly to signed output
    assign out = $signed(in);

endmodule