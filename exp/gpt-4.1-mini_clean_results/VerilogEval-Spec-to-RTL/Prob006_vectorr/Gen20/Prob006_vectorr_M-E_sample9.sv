module TopModule (
    input  wire [7:0] in,
    output wire [7:0] out
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_reverse_loop
            assign out[i] = in[7 - i];
        end
    endgenerate
endmodule