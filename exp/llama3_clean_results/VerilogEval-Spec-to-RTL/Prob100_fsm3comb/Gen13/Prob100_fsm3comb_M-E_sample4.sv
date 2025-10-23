module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

reg [1:0] lut_next_state [4][2];
reg [0:0] lut_out [4][2];

initial begin
    // Initialize the LUT based on the state transition table
    lut_next_state[0][0] = 2'b00; lut_out[0][0] = 1'b0; // State A, in=0
    lut_next_state[0][1] = 2'b01; lut_out[0][1] = 1'b0; // State A, in=1
    
    lut_next_state[1][0] = 2'b10; lut_out[1][0] = 1'b0; // State B, in=0
    lut_next_state[1][1] = 2'b01; lut_out[1][1] = 1'b0; // State B, in=1
    
    lut_next_state[2][0] = 2'b00; lut_out[2][0] = 1'b0; // State C, in=0
    lut_next_state[2][1] = 2'b11; lut_out[2][1] = 1'b0; // State C, in=1
    
    lut_next_state[3][0] = 2'b10; lut_out[3][0] = 1'b1; // State D, in=0
    lut_next_state[3][1] = 2'b01; lut_out[3][1] = 1'b1; // State D, in=1
end

always @(state, in) begin
    next_state = lut_next_state[state][in];
    out = lut_out[state][in];
end

endmodule