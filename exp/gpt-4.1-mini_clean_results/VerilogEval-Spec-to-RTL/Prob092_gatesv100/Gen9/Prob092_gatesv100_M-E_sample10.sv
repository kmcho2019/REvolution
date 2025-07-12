module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : gen_bits
        // out_both: check if bit and left neighbor (bit+1) are both 1
        // If no left neighbor (i=99), out_both=0
        if (i < 99) begin
            assign out_both[i] = in[i] & in[i+1];
        end else begin
            assign out_both[i] = 1'b0;
        end

        // out_any: check if bit or right neighbor (bit-1) is 1
        // If no right neighbor (i=0), out_any=0
        if (i > 0) begin
            assign out_any[i] = in[i] | in[i-1];
        end else begin
            assign out_any[i] = 1'b0;
        end

        // out_different: check if bit differs from left neighbor (with wrap-around)
        // For i=0, left neighbor is in[99]
        if (i == 0) begin
            assign out_different[i] = in[i] ^ in[99];
        end else begin
            assign out_different[i] = in[i] ^ in[i-1];
        end
    end
endgenerate

endmodule