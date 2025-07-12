module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Simplified population count by directly summing input bits
    assign out = in[0] + in[1] + in[2];

endmodule