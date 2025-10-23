module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // LUT-based sign extension
    wire [23:0] ext_pattern = in[7] ? 24'hFFFFFF : 24'h000000;
    assign out = {ext_pattern, in};
endmodule