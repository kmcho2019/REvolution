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
            wire left_neighbor = (i == 99)? 1'b0 : in[i+1];
            assign out_both[i] = in[i] && left_neighbor;

            // out_any: Check if current bit or its neighbor to the right are '1'
            wire right_neighbor = (i == 0)? 1'b0 : in[i-1];
            assign out_any[i] = in[i] || right_neighbor;

            // out_different: Check if current bit is different from its neighbor to the left (wrap-around)
            wire wrapped_left_neighbor = (i == 99)? in[0] : in[i+1];
            assign out_different[i] = in[i] ^ wrapped_left_neighbor;
        end
    endgenerate

endmodule