module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // out_both
            assign out_both[i] = (i < 3)? (in[i] & in[i+1]) : 1'b0;
            
            // out_any
            assign out_any[i] = (i == 0)? in[i] : (in[i] | in[i-1]);
            
            // out_different
            assign out_different[i] = (i == 3)? (in[i] ^ in[0]) : (in[i] ^ in[i+1]);
        end
    endgenerate
endmodule