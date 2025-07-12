module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Use reduction addition to count the number of '1's
    assign out = in[0] + in[1] + in[2];

endmodule