module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output valid
);

reg [3:0] decode_rom [0:255];

// Initialize the ROM with known scancode mappings
integer i;
initial begin
    // Default all to 0
    for (i = 0; i < 256; i = i + 1)
        decode_rom[i] = 4'd0;

    decode_rom[8'h45] = 4'd0;
    decode_rom[8'h16] = 4'd1;
    decode_rom[8'h1E] = 4'd2;
    decode_rom[8'h26] = 4'd3;
    decode_rom[8'h25] = 4'd4;
    decode_rom[8'h2E] = 4'd5;
    decode_rom[8'h36] = 4'd6;
    decode_rom[8'h3D] = 4'd7;
    decode_rom[8'h3E] = 4'd8;
    decode_rom[8'h46] = 4'd9;
end

always @(*) begin
    out = decode_rom[code];
end

// valid is high if code matches any known key
// Special case for 0, since out=0 can be from default and from code 8'h45
assign valid = (code == 8'h45) || 
               (code == 8'h16) || 
               (code == 8'h1E) || 
               (code == 8'h26) || 
               (code == 8'h25) || 
               (code == 8'h2E) || 
               (code == 8'h36) || 
               (code == 8'h3D) || 
               (code == 8'h3E) || 
               (code == 8'h46);

endmodule