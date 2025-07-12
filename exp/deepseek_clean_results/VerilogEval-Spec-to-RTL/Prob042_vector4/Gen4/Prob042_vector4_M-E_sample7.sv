module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Define extension patterns
    wire [23:0] ext_pattern = in[7] ? 24'hFFFFFF : 24'h000000;
    
    // Combine with original input
    assign out = {ext_pattern, in};
endmodule