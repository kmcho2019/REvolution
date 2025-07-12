module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Lookup table for next state and z
reg [2:0] lut_next_state [8][2]; // 2^3 (for y) x 2 (for x)
reg [7:0] lut_z [8][2];

// Initialization of LUTs
initial begin
    // Next state LUT
    lut_next_state[0][0] = 3'b000; lut_next_state[0][1] = 3'b001;
    lut_next_state[1][0] = 3'b001; lut_next_state[1][1] = 3'b100;
    lut_next_state[2][0] = 3'b010; lut_next_state[2][1] = 3'b001;
    lut_next_state[3][0] = 3'b001; lut_next_state[3][1] = 3'b010;
    lut_next_state[4][0] = 3'b011; lut_next_state[4][1] = 3'b100;
    lut_next_state[5][0] = 3'b000; lut_next_state[5][1] = 3'b000; // Unused states default to 000
    lut_next_state[6][0] = 3'b000; lut_next_state[6][1] = 3'b000;
    lut_next_state[7][0] = 3'b000; lut_next_state[7][1] = 3'b000;
    
    // z LUT
    lut_z[0][0] = 1'b0; lut_z[0][1] = 1'b0;
    lut_z[1][0] = 1'b0; lut_z[1][1] = 1'b0;
    lut_z[2][0] = 1'b0; lut_z[2][1] = 1'b0;
    lut_z[3][0] = 1'b1; lut_z[3][1] = 1'b1;
    lut_z[4][0] = 1'b1; lut_z[4][1] = 1'b1;
    lut_z[5][0] = 1'b0; lut_z[5][1] = 1'b0; // Unused states default to 0
    lut_z[6][0] = 1'b0; lut_z[6][1] = 1'b0;
    lut_z[7][0] = 1'b0; lut_z[7][1] = 1'b0;
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Combinational logic using LUTs
always @ (*) begin
    next_state = lut_next_state[y][x];
    z = lut_z[y][x][0]; // Directly use the LUT value for z
end

// Directly assign output Y0 from next_state
assign Y0 = next_state[0];

endmodule