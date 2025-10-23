module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    genvar i;
    wire [31:0] out_w;

    generate
        for (i = 0; i < 4; i = i + 1) begin : byte_reverse
            assign out_w[8*i +: 8] = in[8*(3 - i) +: 8];
        end
    endgenerate

    assign out = out_w;

endmodule