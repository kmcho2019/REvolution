module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Combined storage for out[3:0] and valid
reg [4:0] rom [255:0];

// Initialize ROM - default all entries to 5'b00000
integer i;
initial begin
    for (i = 0; i < 256; i = i + 1) begin
        rom[i] = 5'b00000;
    end
    
    // Set valid entries
    rom[8'h45] = 5'b00001; // 0
    rom[8'h16] = 5'b10001; // 1
    rom[8'h1e] = 5'b00011; // 2
    rom[8'h26] = 5'b10011; // 3
    rom[8'h25] = 5'b00101; // 4
    rom[8'h2e] = 5'b10101; // 5
    rom[8'h36] = 5'b00111; // 6
    rom[8'h3d] = 5'b10111; // 7
    rom[8'h3e] = 5'b01001; // 8
    rom[8'h46] = 5'b11001; // 9
end

// Output assignment
assign {out, valid} = rom[code];

endmodule