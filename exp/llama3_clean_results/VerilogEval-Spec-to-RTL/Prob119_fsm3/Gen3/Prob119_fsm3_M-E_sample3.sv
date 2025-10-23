module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the number of states
parameter NUM_STATES = 4;

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Define the ROM data
reg [1:0] rom_data [0:15];
initial begin
    // Initialize the ROM with the next state and output for each possible combination
    rom_data[0] = {A, 1'b0}; // A, in=0
    rom_data[1] = {B, 1'b0}; // A, in=1
    rom_data[2] = {C, 1'b0}; // B, in=0
    rom_data[3] = {B, 1'b0}; // B, in=1
    rom_data[4] = {A, 1'b0}; // C, in=0
    rom_data[5] = {D, 1'b0}; // C, in=1
    rom_data[6] = {C, 1'b1}; // D, in=0
    rom_data[7] = {B, 1'b1}; // D, in=1
    rom_data[8] = {A, 1'b0}; // A, in=0 ( duplicate for other states )
    rom_data[9] = {B, 1'b0}; // A, in=1
    rom_data[10] = {C, 1'b0}; // B, in=0
    rom_data[11] = {B, 1'b0}; // B, in=1
    rom_data[12] = {A, 1'b0}; // C, in=0
    rom_data[13] = {D, 1'b0}; // C, in=1
    rom_data[14] = {C, 1'b1}; // D, in=0
    rom_data[15] = {B, 1'b1}; // D, in=1
end

// State register
reg [1:0] state;

// Address generation for the ROM
wire [3:0] addr;
assign addr = {state, in};

// ROM output
wire [1:0] next_state;
wire out_rom;
assign next_state = rom_data[addr][1:0];
assign out_rom = rom_data[addr][2];

// State register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

// Output logic
assign out = out_rom;

endmodule