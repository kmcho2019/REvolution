module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;
reg output_z;

// Lookup table for next state and output
reg [2:0] lut_next_state [8];
reg [0:0] lut_output_z [8];

initial begin
    // Initialize lookup table
    lut_next_state[0] = 3'b000; lut_output_z[0] = 1'b0; // y=000, x=0
    lut_next_state[1] = 3'b001; lut_output_z[1] = 1'b0; // y=000, x=1
    lut_next_state[2] = 3'b001; lut_output_z[2] = 1'b0; // y=001, x=0
    lut_next_state[3] = 3'b100; lut_output_z[3] = 1'b0; // y=001, x=1
    lut_next_state[4] = 3'b010; lut_output_z[4] = 1'b0; // y=010, x=0
    lut_next_state[5] = 3'b001; lut_output_z[5] = 1'b0; // y=010, x=1
    lut_next_state[6] = 3'b001; lut_output_z[6] = 1'b1; // y=011, x=0
    lut_next_state[7] = 3'b010; lut_output_z[7] = 1'b1; // y=011, x=1
    lut_next_state[8] = 3'b011; lut_output_z[8] = 1'b1; // y=100, x=0
    lut_next_state[9] = 3'b100; lut_output_z[9] = 1'b1; // y=100, x=1
end

// Combinational logic for next state and output
always @ (*) begin
    reg [4:0] address;
    address = {y, x, 1'b0}; // Create 5-bit address
    case (address)
        5'b00000: {next_state, output_z} = {lut_next_state[0], lut_output_z[0]};
        5'b00001: {next_state, output_z} = {lut_next_state[1], lut_output_z[1]};
        5'b00100: {next_state, output_z} = {lut_next_state[2], lut_output_z[2]};
        5'b00101: {next_state, output_z} = {lut_next_state[3], lut_output_z[3]};
        5'b01000: {next_state, output_z} = {lut_next_state[4], lut_output_z[4]};
        5'b01001: {next_state, output_z} = {lut_next_state[5], lut_output_z[5]};
        5'b01100: {next_state, output_z} = {lut_next_state[6], lut_output_z[6]};
        5'b01101: {next_state, output_z} = {lut_next_state[7], lut_output_z[7]};
        5'b10000: {next_state, output_z} = {lut_next_state[8], lut_output_z[8]};
        5'b10001: {next_state, output_z} = {lut_next_state[9], lut_output_z[9]};
        default: {next_state, output_z} = {3'b000, 1'b0};
    endcase
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

assign Y0 = next_state[0];
assign z = output_z;

// Initialize state
initial begin
    current_state = 3'b000;
end

endmodule