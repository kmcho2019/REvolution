module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// 256x5 memory (8-bit address, 5-bit data: 4-bit out + 1-bit valid)
reg [4:0] scancode_lut [0:255];

// Initialize the LUT
integer i;
initial begin
    // Initialize all entries to 0
    for (i = 0; i < 256; i = i + 1) begin
        scancode_lut[i] = 5'b0;
    end
    
    // Set valid entries
    scancode_lut[8'h45] = 5'b00001; // 0, valid
    scancode_lut[8'h16] = 5'b10011; // 1, valid
    scancode_lut[8'h1e] = 5'b01001; // 2, valid
    scancode_lut[8'h26] = 5'b11001; // 3, valid
    scancode_lut[8'h25] = 5'b00101; // 4, valid
    scancode_lut[8'h2e] = 5'b10101; // 5, valid
    scancode_lut[8'h36] = 5'b01101; // 6, valid
    scancode_lut[8'h3d] = 5'b11101; // 7, valid
    scancode_lut[8'h3e] = 5'b00011; // 8, valid
    scancode_lut[8'h46] = 5'b10011; // 9, valid
end

// Output the decoded values
wire [4:0] decoded = scancode_lut[code];
assign out = decoded[3:0];
assign valid = decoded[4];

endmodule