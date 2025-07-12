module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Directly sum the bits of 'in' to get population count (0 to 3)
    assign out = in[0] + in[1] + in[2];

endmodule