module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Check if first byte is 0xE0 (common for all arrow keys)
    wire is_arrow = (scancode[15:8] == 8'he0);
    
    // Extract relevant bits from second byte (masking unnecessary bits)
    wire [3:0] key_code = scancode[3:0] & 4'b1111;
    
    // Parallel pattern matching using bitwise operations
    assign left  = is_arrow & (key_code == 4'b1011);  // 0x6b[3:0] = 1011
    assign down  = is_arrow & (key_code == 4'b0010);  // 0x72[3:0] = 0010
    assign right = is_arrow & (key_code == 4'b0100);  // 0x74[3:0] = 0100
    assign up    = is_arrow & (key_code == 4'b0101);  // 0x75[3:0] = 0101

endmodule