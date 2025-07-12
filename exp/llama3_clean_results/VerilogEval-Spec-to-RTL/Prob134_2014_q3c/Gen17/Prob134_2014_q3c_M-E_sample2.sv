module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;
reg z_reg;

// LUT to store next state and output values
reg [2:0] lut_next_state [0:7];
reg [0:0] lut_z [0:7];

// Initialize LUT
initial begin
    lut_next_state[0] = 3'b000; // y = 000, x = 0
    lut_z[0] = 1'b0;
    lut_next_state[1] = 3'b001; // y = 000, x = 1
    lut_z[1] = 1'b0;
    lut_next_state[2] = 3'b001; // y = 001, x = 0
    lut_z[2] = 1'b0;
    lut_next_state[3] = 3'b100; // y = 001, x = 1
    lut_z[3] = 1'b0;
    lut_next_state[4] = 3'b010; // y = 010, x = 0
    lut_z[4] = 1'b0;
    lut_next_state[5] = 3'b001; // y = 010, x = 1
    lut_z[5] = 1'b0;
    lut_next_state[6] = 3'b001; // y = 011, x = 0
    lut_z[6] = 1'b1;
    lut_next_state[7] = 3'b010; // y = 011, x = 1
    lut_z[7] = 1'b1;
    lut_next_state[8] = 3'b011; // y = 100, x = 0
    lut_z[8] = 1'b1;
    lut_next_state[9] = 3'b100; // y = 100, x = 1
    lut_z[9] = 1'b1;
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
    z_reg <= lut_z[{y, x}];
end

// Combinational logic for next state
always @ (*) begin
    next_state = lut_next_state[{y, x}];
end

// Directly assign output Y0 from next_state
assign Y0 = next_state[0];
assign z = z_reg;

endmodule