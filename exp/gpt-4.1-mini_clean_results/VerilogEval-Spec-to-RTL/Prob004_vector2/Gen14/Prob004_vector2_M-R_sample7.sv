module TopModule (
    input  [31:0] in,
    output [31:0] out
);

genvar i;
wire [31:0] reversed_bytes;

generate
    for (i = 0; i < 4; i = i + 1) begin : byte_reverse_loop
        assign reversed_bytes[(i*8)+7 -: 8] = in[(3 - i)*8 + 7 -: 8];
    end
endgenerate

assign out = reversed_bytes;

endmodule