module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // out_both: Check if current bit and its left neighbor are both 1
            assign out_both[i] = (i < 3) ? in[i] & in[i+1] : 1'b0;
            
            // out_any: Check if current bit or its right neighbor is 1
            assign out_any[i] = (i > 0) ? in[i] | in[i-1] : in[i];
            
            // out_different: Check if current bit is different from its left neighbor (wrapping around for the last bit)
            assign out_different[i] = (i == 3) ? in[i] ^ in[0] : in[i] ^ in[i+1];
        end
    endgenerate
endmodule