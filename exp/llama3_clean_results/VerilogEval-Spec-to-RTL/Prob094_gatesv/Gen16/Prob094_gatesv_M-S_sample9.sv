module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // For out_both, assign 0 when at the most significant bit, otherwise perform AND operation
            assign out_both[i] = (i == 3) ? 1'b0 : in[i] & in[i+1];
            
            // For out_any, assign input value when at the least significant bit, otherwise perform OR operation
            assign out_any[i] = (i == 0) ? in[i] : in[i] | in[i-1];
            
            // For out_different, perform XOR operation, wrapping around for the most significant bit
            assign out_different[i] = (i == 3) ? in[i] ^ in[0] : in[i] ^ in[i+1];
        end
    endgenerate
endmodule