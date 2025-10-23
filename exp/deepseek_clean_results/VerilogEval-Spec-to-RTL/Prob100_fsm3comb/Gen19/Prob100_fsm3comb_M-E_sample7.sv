module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// State transition LUT: 
// Format: {next_state_if_in1_stateD, next_state_if_in0_stateD,
//          next_state_if_in1_stateC, next_state_if_in0_stateC,
//          next_state_if_in1_stateB, next_state_if_in0_stateB,
//          next_state_if_in1_stateA, next_state_if_in0_stateA}
parameter [15:0] TRANSITION_LUT = 16'b01_10_01_00_10_00_01_00;

always @(*) begin
    // Moore output - only high in state D
    out = (state == 2'b11);
    
    // State transition via LUT lookup
    // The index is {state, in} (3 bits total)
    case ({state, in})
        3'b000: next_state = TRANSITION_LUT[1:0];   // state A, in=0
        3'b001: next_state = TRANSITION_LUT[3:2];   // state A, in=1
        3'b010: next_state = TRANSITION_LUT[5:4];   // state B, in=0
        3'b011: next_state = TRANSITION_LUT[7:6];   // state B, in=1
        3'b100: next_state = TRANSITION_LUT[9:8];   // state C, in=0
        3'b101: next_state = TRANSITION_LUT[11:10]; // state C, in=1
        3'b110: next_state = TRANSITION_LUT[13:12]; // state D, in=0
        3'b111: next_state = TRANSITION_LUT[15:14]; // state D, in=1
        default: next_state = 2'b00;               // should never occur
    endcase
end

endmodule