module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    // Define the lookup tables for next state and output logic
    wire [1:0] next_state_lut [4];
    wire [0:0] out_lut [4];

    // Initialize the lookup tables
    assign next_state_lut[0] = (in)? 2'b01 : 2'b00; // State A
    assign next_state_lut[1] = (in)? 2'b01 : 2'b10; // State B
    assign next_state_lut[2] = (in)? 2'b11 : 2'b00; // State C
    assign next_state_lut[3] = (in)? 2'b01 : 2'b10; // State D

    assign out_lut[0] = 1'b0; // State A
    assign out_lut[1] = 1'b0; // State B
    assign out_lut[2] = 1'b0; // State C
    assign out_lut[3] = 1'b1; // State D

    // Determine the next state and output based on the current state and input
    assign next_state = next_state_lut[state];
    assign out = out_lut[state];

endmodule