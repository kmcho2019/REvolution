module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    // Define the LUT for next state
    reg [1:0] next_state_LUT [3:0];
    always @(state, in) begin
        case({state, in})
            4'b0000: next_state_LUT[0] = 2'b00; // State A, in=0
            4'b0001: next_state_LUT[0] = 2'b01; // State A, in=1
            4'b0100: next_state_LUT[1] = 2'b10; // State B, in=0
            4'b0101: next_state_LUT[1] = 2'b01; // State B, in=1
            4'b1000: next_state_LUT[2] = 2'b00; // State C, in=0
            4'b1001: next_state_LUT[2] = 2'b11; // State C, in=1
            4'b1100: next_state_LUT[3] = 2'b10; // State D, in=0
            4'b1101: next_state_LUT[3] = 2'b01; // State D, in=1
            default: next_state_LUT[0] = 2'b00; // Default next state is A
        endcase
    end

    // Define the LUT for output
    reg out_LUT [3:0];
    always @(state) begin
        case(state)
            2'b00: out_LUT[0] = 1'b0; // State A
            2'b01: out_LUT[1] = 1'b0; // State B
            2'b10: out_LUT[2] = 1'b0; // State C
            2'b11: out_LUT[3] = 1'b1; // State D
            default: out_LUT[0] = 1'b0; // Default output is 0
        endcase
    end

    // Assign next state and output from LUTs
    always @(state, in) begin
        next_state = next_state_LUT[{state, in}];
    end

    assign out = out_LUT[state];

endmodule