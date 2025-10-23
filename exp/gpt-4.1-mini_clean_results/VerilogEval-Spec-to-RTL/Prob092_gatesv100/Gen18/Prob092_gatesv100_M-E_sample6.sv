module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;

    // out_both[i] = in[i] & in[i+1] for i=0 to 98, out_both[99] = 0
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1 to 99, out_any[0] = 0
    generate
        for (i = 1; i < 100; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate
    assign out_any[0] = 1'b0;

    // Create a rotated input vector where rotated_in[i] = in[(i-1) mod 100]
    wire [99:0] rotated_in;
    assign rotated_in = {in[0], in[99:1]};

    // out_different[i] = in[i] ^ rotated_in[i]
    assign out_different = in ^ rotated_in;

endmodule