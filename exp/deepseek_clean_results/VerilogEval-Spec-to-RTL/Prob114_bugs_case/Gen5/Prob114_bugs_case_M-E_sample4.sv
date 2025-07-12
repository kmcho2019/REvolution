module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Memory array: 256 entries of 5 bits (4-bit out + 1-bit valid)
reg [4:0] scancode_lut [0:255];

// Initialize the LUT
integer i;
initial begin
    // Default all entries to 0
    for (i = 0; i < 256; i = i + 1)
        scancode_lut[i] = 5'b0;
    
    // Set valid entries
    scancode_lut[8'h45] = {4'd0, 1'b1};
    scancode_lut[8'h16] = {4'd1, 1'b1};
    scancode_lut[8'h1e] = {4'd2, 1'b1};
    scancode_lut[8'h26] = {4'd3, 1'b1};
    scancode_lut[8'h25] = {4'd4, 1'b1};
    scancode_lut[8'h2e] = {4'd5, 1'b1};
    scancode_lut[8'h36] = {4'd6, 1'b1};
    scancode_lut[8'h3d] = {4'd7, 1'b1};
    scancode_lut[8'h3e] = {4'd8, 1'b1};
    scancode_lut[8'h46] = {4'd9, 1'b1};
end

// Output assignment
assign {out, valid} = scancode_lut[code];

endmodule