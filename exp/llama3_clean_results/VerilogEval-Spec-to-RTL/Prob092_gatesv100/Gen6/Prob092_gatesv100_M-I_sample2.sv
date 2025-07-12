module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    generate
        for (i = 0; i < 100; i++) begin
            // Simplify out_both logic by directly setting to 0 when i equals 99
            assign out_both[i] = (i < 99) ? (in[i] & in[i+1]) : 1'b0;
            
            // Simplify out_any logic by directly setting to 0 when i equals 0
            assign out_any[i] = (i > 0) ? (in[i] | in[i-1]) : 1'b0;
            
            // Optimize out_different logic using XOR and modulus for wrap-around
            assign out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    endgenerate

endmodule