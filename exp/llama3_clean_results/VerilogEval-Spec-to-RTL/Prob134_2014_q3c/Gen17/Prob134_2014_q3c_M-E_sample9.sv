module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// ROM to store next state values
reg [2:0] rom [8];

// Initialize ROM values
initial begin
    rom[0] = x ? 3'b001 : 3'b000; // y = 000
    rom[1] = x ? 3'b100 : 3'b001; // y = 001
    rom[2] = x ? 3'b001 : 3'b010; // y = 010
    rom[3] = x ? 3'b010 : 3'b001; // y = 011
    rom[4] = x ? 3'b100 : 3'b011; // y = 100
    rom[5] = 3'b000; // y = 101 (don't care)
    rom[6] = 3'b000; // y = 110 (don't care)
    rom[7] = 3'b000; // y = 111 (don't care)
end

// Combinational logic to generate next state
always @ (*) begin
    next_state = rom[y];
end

// Combinational logic to generate output z
always @ (*) begin
    z = (y == 3'b011) || (y == 3'b100);
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

assign Y0 = next_state[0];

endmodule