module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // For out_both, check if current bit and its neighbour to the left are '1'
        // For the most significant bit (in[99]), its neighbour to the left is in[0]
        assign out_both[i] = (i == 99) ? 0 : (in[i] & in[i+1]) ? 1'b1 : 1'b0;

        // For out_any, check if current bit or its neighbour to the right are '1'
        // For the least significant bit (in[0]), its neighbour to the right is in[1]
        assign out_any[i] = (i == 0) ? 0 : (in[i] | in[i-1]) ? 1'b1 : 1'b0;

        // For out_different, check if current bit is different from its neighbour to the left
        // For the most significant bit (in[99]), its neighbour to the left is in[0]
        assign out_different[i] = (i == 99) ? (in[0] != in[99]) ? 1'b1 : 1'b0 : (in[i] != in[i+1]) ? 1'b1 : 1'b0;
    end
endgenerate

endmodule