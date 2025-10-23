module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define lookup tables for next state and output z
reg [2:0] next_state_lut [8][2];
reg [7:0] z_lut [8];

// Initialize lookup tables
initial begin
    // Next state LUT
    next_state_lut[0][0] = 3'b000; next_state_lut[0][1] = 3'b001;
    next_state_lut[1][0] = 3'b001; next_state_lut[1][1] = 3'b100;
    next_state_lut[2][0] = 3'b010; next_state_lut[2][1] = 3'b001;
    next_state_lut[3][0] = 3'b001; next_state_lut[3][1] = 3'b010;
    next_state_lut[4][0] = 3'b011; next_state_lut[4][1] = 3'b100;
    next_state_lut[5][0] = 3'b100; next_state_lut[5][1] = 3'b100;
    next_state_lut[6][0] = 3'b101; next_state_lut[6][1] = 3'b101;
    next_state_lut[7][0] = 3'b110; next_state_lut[7][1] = 3'b110;
    
    // Output z LUT
    z_lut[0] = 8'b00000000;
    z_lut[1] = 8'b00000000;
    z_lut[2] = 8'b00000000;
    z_lut[3] = 8'b00000001;
    z_lut[4] = 8'b00000101;
    z_lut[5] = 8'b00000101;
    z_lut[6] = 8'b00000000;
    z_lut[7] = 8'b00000000;
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state_lut[current_state][x];
end

// Combinational logic for output z
assign z = z_lut[current_state][x];

// Directly assign output Y0 from next state
assign Y0 = next_state_lut[current_state][x][0];

endmodule