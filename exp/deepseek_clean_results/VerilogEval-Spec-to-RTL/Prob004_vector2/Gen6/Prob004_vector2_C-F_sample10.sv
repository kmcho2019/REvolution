module TopModule #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Byte reversal for 32-bit vector (default)
    // Automatically adjusts if WIDTH parameter changes
    assign out = {in[7:0],   in[15:8], 
                 in[23:16], in[31:24]};
endmodule