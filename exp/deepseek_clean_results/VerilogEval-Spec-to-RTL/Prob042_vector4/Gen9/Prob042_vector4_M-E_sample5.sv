module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    wire [23:0] extension_bits = in[7] ? 24'hFFFFFF : 24'h000000;
    assign out = {extension_bits, in};
endmodule