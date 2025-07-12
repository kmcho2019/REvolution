module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Directly assign output to the sum of bits in 'in'
    assign out = in[0] + in[1] + in[2];

endmodule