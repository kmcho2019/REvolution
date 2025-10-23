module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    wire [99:0] a_xor_b = a ^ b;
    wire [99:0] masked_diff = a_xor_b & {100{sel}};
    assign out = a ^ masked_diff;

endmodule