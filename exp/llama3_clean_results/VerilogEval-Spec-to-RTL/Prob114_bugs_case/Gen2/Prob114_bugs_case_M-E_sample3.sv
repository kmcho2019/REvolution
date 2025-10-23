module TopModule (
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

reg [3:0] rom_out [256];
integer i;

initial begin
    // Initialize the ROM with predefined scancode mappings
    rom_out[8'h45] = 4'd0;
    rom_out[8'h16] = 4'd1;
    rom_out[8'h1e] = 4'd2;
    rom_out[8'h26] = 4'd3;
    rom_out[8'h25] = 4'd4;
    rom_out[8'h2e] = 4'd5;
    rom_out[8'h36] = 4'd6;
    rom_out[8'h3d] = 4'd7;
    rom_out[8'h3e] = 4'd8;
    rom_out[8'h46] = 4'd9;
end

always @(*) begin
    // Check if the input scancode is valid by checking the ROM output
    if (rom_out[code] != 4'd0 && code inside {8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46}) begin
        out = rom_out[code];
        valid = 1'b1;
    end else begin
        out = 4'd0;
        valid = 1'b0;
    end
end

endmodule