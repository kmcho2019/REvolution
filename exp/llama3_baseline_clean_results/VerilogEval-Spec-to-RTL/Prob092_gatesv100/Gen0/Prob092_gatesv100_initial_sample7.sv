module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // out_both: Check if current bit and its neighbor to the left are '1'
        assign out_both[i] = (i == 99)? 0 : in[i] & in[i+1];

        // out_any: Check if current bit or its neighbor to the right are '1'
        assign out_any[i] = (i == 0)? 0 : in[i] | in[i-1];

        // out_different: Check if current bit is different from its neighbor to the left
        assign out_different[i] = in[i] ^ (i == 99)? in[0] : in[i+1];
    end
endgenerate

endmodule