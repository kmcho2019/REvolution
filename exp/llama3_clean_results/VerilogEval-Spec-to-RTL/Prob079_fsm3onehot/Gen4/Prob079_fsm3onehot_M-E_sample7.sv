module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Define the lookup table for next states
    reg [3:0] next_state_lut [7:0];
    always @(state, in) begin
        case ({in, state})
            5'b00001: next_state_lut[0] = 4'b0001;
            5'b10001: next_state_lut[1] = 4'b0010;
            5'b00010: next_state_lut[2] = 4'b0100;
            5'b10010: next_state_lut[3] = 4'b0010;
            5'b00100: next_state_lut[4] = 4'b0001;
            5'b10100: next_state_lut[5] = 4'b1000;
            5'b01000: next_state_lut[6] = 4'b0100;
            5'b11000: next_state_lut[7] = 4'b0010;
            default: next_state_lut[0] = 4'bxxxx;
        endcase
    end

    // Define the lookup table for outputs
    reg [0:0] out_lut [7:0];
    always @(state) begin
        case (state)
            4'b0001: out_lut[0] = 1'b0;
            4'b0010: out_lut[1] = 1'b0;
            4'b0100: out_lut[2] = 1'b0;
            4'b1000: out_lut[3] = 1'b1;
            default: out_lut[0] = 1'b0;
        endcase
    end

    // Assign next state and output using the LUTs
    assign next_state = next_state_lut[{in, state[2:0]}];
    assign out = out_lut[state];

endmodule