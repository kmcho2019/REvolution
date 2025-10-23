module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// The entire state transition table encoded as a lookup vector:
// Format: {D_in1, D_in0, C_in1, C_in0, B_in1, B_in0, A_in1, A_in0}
// Where each XY is next_state when in state X with input Y
parameter [7:0] STATE_LUT = 8'b01_10_01_00_10_00_01_00;

// Moore output - depends only on current state
assign out = (state == 2'b11); // Output 1 when in state D (2'b11)

// Next state logic using LUT indexing
always @(*) begin
    case ({state, in})
        3'b000: next_state = STATE_LUT[1:0];   // A, in=0
        3'b001: next_state = STATE_LUT[3:2];   // A, in=1
        3'b010: next_state = STATE_LUT[5:4];   // B, in=0
        3'b011: next_state = STATE_LUT[7:6];   // B, in=1
        3'b100: next_state = STATE_LUT[1:0];   // C, in=0
        3'b101: next_state = STATE_LUT[3:2];   // C, in=1
        3'b110: next_state = STATE_LUT[5:4];   // D, in=0
        3'b111: next_state = STATE_LUT[7:6];   // D, in=1
        default: next_state = 2'b00;           // Should never occur
    endcase
end

endmodule