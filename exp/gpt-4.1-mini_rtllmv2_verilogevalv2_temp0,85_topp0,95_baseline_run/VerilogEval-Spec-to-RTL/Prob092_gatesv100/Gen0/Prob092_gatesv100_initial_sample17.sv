module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1], for i=0 to 98, out_both[99] = 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1], for i=1 to 99, out_any[0] = 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1)%100]
    // We can concatenate in with in[0] at the end and XOR slices
    wire [100:0] in_ext = {in[0], in}; // 101 bits, bit 100 = in[0], bits 99:0 = in
    genvar i;
    generate
        for (i=0; i<100; i=i+1) begin
            assign out_different[i] = in[i] ^ in_ext[i+1];
        end
    endgenerate

endmodule