module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    // Count the number of set bits in 'in' using direct addition of bits for clarity
    // Cast to 2-bit vector explicitly to match output width
    assign out = in[0] + in[1] + in[2];

endmodule