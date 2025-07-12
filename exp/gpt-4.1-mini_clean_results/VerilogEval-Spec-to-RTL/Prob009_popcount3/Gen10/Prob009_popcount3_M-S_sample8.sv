module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Direct sum of the input bits to get the population count
    assign out = in[0] + in[1] + in[2];

endmodule