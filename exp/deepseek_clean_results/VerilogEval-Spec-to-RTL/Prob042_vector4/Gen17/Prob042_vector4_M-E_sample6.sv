module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    wire [23:0] mask = {24{in[7]}};  // Generate mask based on sign bit
    wire [31:0] zero_ext = {24'b0, in};  // Zero-extended version
    
    // Apply mask to upper bits
    assign out = {mask | zero_ext[31:8], in};
endmodule