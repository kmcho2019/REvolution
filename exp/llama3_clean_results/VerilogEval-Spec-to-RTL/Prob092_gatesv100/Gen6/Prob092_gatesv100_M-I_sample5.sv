module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin
            // For out_both, directly using AND operation with neighbor to the right
            assign out_both[i] = (i == 99)? 1'b0 : in[i] & in[i+1];
            
            // For out_any, directly using OR operation with neighbor to the left
            assign out_any[i] = (i == 0)? 1'b0 : in[i] | in[i-1];
            
            // For out_different, using XOR operation to detect difference, handling wrap-around
            assign out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    endgenerate

endmodule