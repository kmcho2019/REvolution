module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;

generate
    for (i = 0; i < 100; i = i + 1) begin
        // out_both: check if current bit and its neighbor to the left are both 1
        // except for the most significant bit which will be set to 0
        assign out_both[i] = (i == 99) ? 0 : (in[i] & in[i+1]);

        // out_any: check if current bit or its neighbor to the right are 1
        // except for the least significant bit which will be set to 0
        assign out_any[i] = (i == 0) ? 0 : (in[i] | in[i-1]);

        // out_different: check if current bit is different from its neighbor to the left
        // treating the vector as circular
        assign out_different[i] = (in[i] != ((i == 99) ? in[0] : in[i+1]));
    end
endgenerate

endmodule