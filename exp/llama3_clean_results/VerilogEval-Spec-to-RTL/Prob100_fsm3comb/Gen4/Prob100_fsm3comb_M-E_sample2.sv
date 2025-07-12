module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    // Define the next state lookup table
    reg [1:0] next_state_lut [4][2];
    always @(*) begin
        next_state_lut[0][0] = 2'b00; // State A, in = 0
        next_state_lut[0][1] = 2'b01; // State A, in = 1
        next_state_lut[1][0] = 2'b10; // State B, in = 0
        next_state_lut[1][1] = 2'b01; // State B, in = 1
        next_state_lut[2][0] = 2'b00; // State C, in = 0
        next_state_lut[2][1] = 2'b11; // State C, in = 1
        next_state_lut[3][0] = 2'b10; // State D, in = 0
        next_state_lut[3][1] = 2'b01; // State D, in = 1
    end

    // Define the output lookup table
    reg out_lut [4];
    always @(*) begin
        out_lut[0] = 1'b0; // State A
        out_lut[1] = 1'b0; // State B
        out_lut[2] = 1'b0; // State C
        out_lut[3] = 1'b1; // State D
    end

    // Determine the next state and output
    always @(*) begin
        next_state = next_state_lut[state][in];
        out = out_lut[state];
    end

endmodule