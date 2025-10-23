module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    generate
        for (i = 0; i < 100; i++) begin
            // out_both: Check if current bit and its left neighbor are both '1'
            // For the most significant bit (i=99), there's no left neighbor, so we set it to 0
            assign out_both[i] = (i == 99)? 1'b0 : (in[i] && in[i+1])? 1'b1 : 1'b0;

            // out_any: Check if current bit or its right neighbor are '1'
            // For the least significant bit (i=0), there's no right neighbor, so we set it to 0
            assign out_any[i] = (i == 0)? 1'b0 : (in[i] || in[i-1])? 1'b1 : 1'b0;

            // out_different: Check if current bit is different from its left neighbor
            // For the most significant bit (i=99), its left neighbor is the least significant bit (in[0])
            assign out_different[i] = (i == 99)? (in[i]!= in[0])? 1'b1 : 1'b0 : (in[i]!= in[i+1])? 1'b1 : 1'b0;
        end
    endgenerate

endmodule