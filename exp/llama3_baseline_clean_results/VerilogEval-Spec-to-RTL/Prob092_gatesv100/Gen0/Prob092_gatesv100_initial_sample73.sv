module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // For out_both, set MSB to 0 and perform bitwise AND for other bits
        if (i == 99) begin
            assign out_both[i] = 0;
        end else begin
            assign out_both[i] = in[i] & in[i+1];
        end

        // For out_any, set LSB to 0 and perform bitwise OR for other bits
        if (i == 0) begin
            assign out_any[i] = 0;
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end

        // For out_different, perform bitwise XOR and wrap around for MSB
        assign out_different[i] = in[i] ^ in[(i+1) % 100];
    end
endgenerate

endmodule