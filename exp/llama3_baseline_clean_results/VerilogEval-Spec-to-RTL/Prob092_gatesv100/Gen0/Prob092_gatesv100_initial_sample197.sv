module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // out_both: check if current bit and its neighbour to the left are both '1'
        // Handle the edge case where i is 99, since in[99] has no neighbour to the left
        assign out_both[i] = (i == 99) ? 0 : in[i] & in[i+1];
        
        // out_any: check if either current bit or its neighbour to the right is '1'
        // Handle the edge case where i is 0, since in[0] has no neighbour to the right
        assign out_any[i] = (i == 0) ? 0 : in[i] | in[i-1];
        
        // out_different: check if current bit is different from its neighbour to the left
        // Handle the wrap-around for the last bit
        assign out_different[i] = (i == 0) ? in[i] != in[99] : in[i] != in[i-1];
    end
endgenerate

endmodule