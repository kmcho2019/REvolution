module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

// Define a lookup table for all possible 8-bit codes
reg [3:0] scancode_lut [255:0];
reg [255:0] valid_mask = 0;

// Initialize the LUT and validity mask
initial begin
    // Default all entries to invalid
    for (integer i = 0; i < 256; i = i + 1) begin
        scancode_lut[i] = 0;
    end
    
    // Set valid entries
    scancode_lut[8'h45] = 0;  valid_mask[8'h45] = 1;
    scancode_lut[8'h16] = 1;  valid_mask[8'h16] = 1;
    scancode_lut[8'h1e] = 2;  valid_mask[8'h1e] = 1;
    scancode_lut[8'h26] = 3;  valid_mask[8'h26] = 1;
    scancode_lut[8'h25] = 4;  valid_mask[8'h25] = 1;
    scancode_lut[8'h2e] = 5;  valid_mask[8'h2e] = 1;
    scancode_lut[8'h36] = 6;  valid_mask[8'h36] = 1;
    scancode_lut[8'h3d] = 7;  valid_mask[8'h3d] = 1;
    scancode_lut[8'h3e] = 8;  valid_mask[8'h3e] = 1;
    scancode_lut[8'h46] = 9;  valid_mask[8'h46] = 1;
end

always @(*) begin
    out = scancode_lut[code];
    valid = valid_mask[code];
end

endmodule