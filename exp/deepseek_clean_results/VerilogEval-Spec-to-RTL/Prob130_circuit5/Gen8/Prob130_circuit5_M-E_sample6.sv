module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// ROM implementation for control signals
reg [3:0] rom [0:3];
initial begin
    rom[0] = 4'b0001; // Select b when c[1:0] == 0
    rom[1] = 4'b0010; // Select e when c[1:0] == 1
    rom[2] = 4'b0100; // Select a when c[1:0] == 2
    rom[3] = 4'b1000; // Select d when c[1:0] == 3
end

wire [3:0] rom_out = rom[c[1:0]];
wire default_case = (c > 4'b0011);

// Tri-state buffer implementation
wire [3:0] b_buf = rom_out[0] ? b : 4'bz;
wire [3:0] e_buf = rom_out[1] ? e : 4'bz;
wire [3:0] a_buf = rom_out[2] ? a : 4'bz;
wire [3:0] d_buf = rom_out[3] ? d : 4'bz;

// Final output selection
assign q = default_case ? 4'b1111 : 
           (b_buf | e_buf | a_buf | d_buf);

endmodule