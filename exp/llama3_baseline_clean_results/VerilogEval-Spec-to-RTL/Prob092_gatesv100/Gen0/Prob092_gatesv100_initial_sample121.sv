module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // For out_both, check if the current bit and its neighbour to the left are both '1'
        // If i is 99, set out_both to 0 since there is no neighbour to the left
        assign out_both[i] = (i == 99)? 1'b0 : in[i] & in[i + 1];

        // For out_any, check if either the current bit or its neighbour to the right is '1'
        // If i is 0, set out_any to 0 since there is no neighbour to the right
        assign out_any[i] = (i == 0)? 1'b0 : in[i] | in[i - 1];

        // For out_different, check if the current bit is different from its neighbour to the left
        // If i is 99, its neighbour to the left is in[0]
        assign out_different[i] = (i == 99)? in[i] ^ in[0] : in[i] ^ in[i + 1];
    end
endgenerate

endmodule