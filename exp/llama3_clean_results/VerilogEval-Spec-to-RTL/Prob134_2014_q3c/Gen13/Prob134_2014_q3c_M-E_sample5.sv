module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the lookup table (LUT) for next state and output
reg [2:0] lut_next_state [8][2];
reg [0:0] lut_output [8][2];

initial begin
    // Initialize the LUT for next state
    lut_next_state[0][0] = 3'b000; lut_next_state[0][1] = 3'b001;
    lut_next_state[1][0] = 3'b001; lut_next_state[1][1] = 3'b100;
    lut_next_state[2][0] = 3'b010; lut_next_state[2][1] = 3'b001;
    lut_next_state[3][0] = 3'b001; lut_next_state[3][1] = 3'b010;
    lut_next_state[4][0] = 3'b011; lut_next_state[4][1] = 3'b100;
    lut_next_state[5][0] = 3'b100; lut_next_state[5][1] = 3'b100;
    lut_next_state[6][0] = 3'b010; lut_next_state[6][1] = 3'b001;
    lut_next_state[7][0] = 3'b011; lut_next_state[7][1] = 3'b010;
    
    // Initialize the LUT for output
    lut_output[0][0] = 1'b0; lut_output[0][1] = 1'b0;
    lut_output[1][0] = 1'b0; lut_output[1][1] = 1'b0;
    lut_output[2][0] = 1'b0; lut_output[2][1] = 1'b0;
    lut_output[3][0] = 1'b1; lut_output[3][1] = 1'b1;
    lut_output[4][0] = 1'b1; lut_output[4][1] = 1'b1;
    lut_output[5][0] = 1'b1; lut_output[5][1] = 1'b1;
    lut_output[6][0] = 1'b0; lut_output[6][1] = 1'b0;
    lut_output[7][0] = 1'b1; lut_output[7][1] = 1'b1;
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Combinational logic for next state and output
always @ (*) begin
    // Use the LUT to determine the next state and output
    next_state = lut_next_state[y][x];
    z = lut_output[y][x];
end

// Directly assign output Y0 from next_state
assign Y0 = next_state[0];

endmodule