module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Pre-computed extension patterns
    wire [23:0] extension_pattern = in[7] ? 24'hFFFFFF : 24'h000000;
    
    assign out = {extension_pattern, in};
endmodule