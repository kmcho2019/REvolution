module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// out_both[i] = in[i] & in[i+1] for i=0..98, out_both[99]=0
genvar i;
generate
    for (i = 0; i < 99; i = i + 1) begin : gen_out_both
        assign out_both[i] = in[i] & in[i+1];
    end
endgenerate
assign out_both[99] = 1'b0;

// out_any[i] = in[i] | in[i-1] for i=1..99, out_any[0]=0
generate
    for (i = 1; i < 100; i = i + 1) begin : gen_out_any
        assign out_any[i] = in[i] | in[i-1];
    end
endgenerate
assign out_any[0] = 1'b0;

// out_different[i] = in[i] ^ in[(i+1) mod 100]
// For i=0..98, neighbor is i+1
// For i=99, neighbor is 0 (wrap around)
generate
    for (i = 0; i < 99; i = i + 1) begin : gen_out_different
        assign out_different[i] = in[i] ^ in[i+1];
    end
endgenerate
assign out_different[99] = in[99] ^ in[0];

endmodule