module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Directly assign the 2-bit population count by adding the individual bits
    assign out = in[0] + in[1] + in[2];

endmodule