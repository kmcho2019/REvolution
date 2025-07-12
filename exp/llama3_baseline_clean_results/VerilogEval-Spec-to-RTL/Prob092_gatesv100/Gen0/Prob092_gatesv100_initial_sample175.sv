module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;

generate
    for (i = 0; i < 100; i++) begin
        // out_both: current bit and its left neighbor are both '1'
        assign out_both[i] = (i == 99) ? 1'b0 : (in[i] & in[i + 1]);

        // out_any: current bit or its right neighbor is '1'
        assign out_any[i] = (i == 0) ? 1'b0 : (in[i] | in[i - 1]);

        // out_different: current bit is different from its left neighbor
        assign out_different[i] = (i == 99) ? (in[99] != in[0]) : (in[i] != in[i + 1]);
    end
endgenerate

endmodule