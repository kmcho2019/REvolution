module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin
        // For out_both, perform AND operation with left neighbor, except for the most significant bit
        assign out_both[i] = (i == 99) ? 1'b0 : in[i] & in[i+1];
        
        // For out_any, perform OR operation with right neighbor, except for the least significant bit
        assign out_any[i] = (i == 0) ? 1'b0 : in[i] | in[i-1];
        
        // For out_different, perform XOR operation with left neighbor, wrapping around for the most significant bit
        assign out_different[i] = in[i] ^ ((i == 99) ? in[0] : in[i+1]);
    end
endgenerate

endmodule