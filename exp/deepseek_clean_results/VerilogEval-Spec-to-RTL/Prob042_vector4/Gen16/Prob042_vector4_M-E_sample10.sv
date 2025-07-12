module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Pre-computed extension patterns
    wire [23:0] ext_pattern = in[7] ? 24'hFFFFFF : 24'h000000;
    
    // Select appropriate extension and concatenate
    assign out = {ext_pattern, in};
endmodule