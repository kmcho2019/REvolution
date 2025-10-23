module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Count the number of ones in the input vector by summing bits
    assign out = in[0] + in[1] + in[2];

endmodule