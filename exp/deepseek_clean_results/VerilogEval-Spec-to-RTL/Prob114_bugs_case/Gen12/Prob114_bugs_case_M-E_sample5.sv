module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// ROM implementation using a case statement
reg [3:0] rom [0:255];
integer i;

initial begin
    // Initialize all entries to 0
    for (i = 0; i < 256; i = i + 1)
        rom[i] = 4'd0;
    
    // Set valid key codes
    rom[8'h45] = 4'd0;
    rom[8'h16] = 4'd1;
    rom[8'h1e] = 4'd2;
    rom[8'h26] = 4'd3;
    rom[8'h25] = 4'd4;
    rom[8'h2e] = 4'd5;
    rom[8'h36] = 4'd6;
    rom[8'h3d] = 4'd7;
    rom[8'h3e] = 4'd8;
    rom[8'h46] = 4'd9;
end

// Output assignments
assign out = rom[code];
assign valid = |rom[code];  // Valid if output is non-zero

endmodule