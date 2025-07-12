module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the lookup table
reg [2:0] lut_next_state [8];
reg [7:0] lut_output [8];

initial begin
    // Initialize the lookup table
    lut_next_state[0] = 3'b000; // 000, x=0
    lut_next_state[1] = 3'b001; // 000, x=1
    lut_next_state[2] = 3'b001; // 001, x=0
    lut_next_state[3] = 3'b100; // 001, x=1
    lut_next_state[4] = 3'b010; // 010, x=0
    lut_next_state[5] = 3'b001; // 010, x=1
    lut_next_state[6] = 3'b001; // 011, x=0
    lut_next_state[7] = 3'b010; // 011, x=1

    lut_output[0] = 8'b00000000; // 000, x=0
    lut_output[1] = 8'b00000000; // 000, x=1
    lut_output[2] = 8'b00000000; // 001, x=0
    lut_output[3] = 8'b00000000; // 001, x=1
    lut_output[4] = 8'b00000000; // 010, x=0
    lut_output[5] = 8'b00000000; // 010, x=1
    lut_output[6] = 8'b00000001; // 011, x=0
    lut_output[7] = 8'b00000001; // 011, x=1
    lut_output[8] = 8'b00000001; // 100, x=0
    lut_output[9] = 8'b00000001; // 100, x=1
end

// Combinational logic for next state and output
always @ (*) begin
    case ({y, x})
        4'b0000: {next_state, z} = {lut_next_state[0], lut_output[0][0]};
        4'b0001: {next_state, z} = {lut_next_state[1], lut_output[1][0]};
        4'b0010: {next_state, z} = {lut_next_state[2], lut_output[2][0]};
        4'b0011: {next_state, z} = {lut_next_state[3], lut_output[3][0]};
        4'b0100: {next_state, z} = {lut_next_state[4], lut_output[4][0]};
        4'b0101: {next_state, z} = {lut_next_state[5], lut_output[5][0]};
        4'b0110: {next_state, z} = {lut_next_state[6], lut_output[6][0]};
        4'b0111: {next_state, z} = {lut_next_state[7], lut_output[7][0]};
        4'b1000: {next_state, z} = {lut_next_state[8], lut_output[8][0]};
        4'b1001: {next_state, z} = {lut_next_state[9], lut_output[9][0]};
        default: {next_state, z} = {3'b000, 1'b0};
    endcase
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Directly assign output Y0 from next_state
assign Y0 = next_state[0];

endmodule