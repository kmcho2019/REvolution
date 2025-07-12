module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

genvar i;

generate
    // Compute out_both:
    // For i=0..98: out_both[i] = in[i] & in[i+1]
    // For i=99: out_both[99] = 0
    for (i = 0; i < 99; i = i + 1) begin : gen_out_both
        assign out_both[i] = in[i] & in[i+1];
    end
    assign out_both[99] = 1'b0;
endgenerate

generate
    // Compute out_any:
    // For i=1..99: out_any[i] = in[i] | in[i-1]
    // For i=0: out_any[0] = 0
    assign out_any[0] = 1'b0;
    for (i = 1; i < 100; i = i + 1) begin : gen_out_any
        assign out_any[i] = in[i] | in[i-1];
    end
endgenerate

generate
    // Compute out_different:
    // For i=0..98: out_different[i] = in[i] ^ in[i+1]
    // For i=99: out_different[99] = in[99] ^ in[0]
    for (i = 0; i < 99; i = i + 1) begin : gen_out_different_linear
        assign out_different[i] = in[i] ^ in[i+1];
    end
    assign out_different[99] = in[99] ^ in[0];
endgenerate

endmodule