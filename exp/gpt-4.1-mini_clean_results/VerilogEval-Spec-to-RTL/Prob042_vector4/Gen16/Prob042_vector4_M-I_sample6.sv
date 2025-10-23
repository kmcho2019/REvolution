module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Sign-extend by replicating the sign bit 24 times and concatenating with the input
    assign out = { {24{in[7]}}, in };

endmodule