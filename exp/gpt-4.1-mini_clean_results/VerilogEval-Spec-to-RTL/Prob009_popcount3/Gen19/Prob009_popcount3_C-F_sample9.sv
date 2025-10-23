module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Compute population count by summing individual bits of input
    // This produces a 2-bit result representing the number of '1's in 'in'
    assign out = in[0] + in[1] + in[2];

endmodule