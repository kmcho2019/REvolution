module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Combined next state and output LUT
// Format: {next_state, out} for each {state, in} combination
// Index is {state[1:0], in}
wire [2:0] lut_out;
assign lut_out = (3'b000) ? 3'b000 :  // A,0->A,0
                 (3'b001) ? 3'b010 :  // A,1->B,0
                 (3'b010) ? 3'b100 :  // B,0->C,0
                 (3'b011) ? 3'b010 :  // B,1->B,0
                 (3'b100) ? 3'b000 :  // C,0->A,0
                 (3'b101) ? 3'b111 :  // C,1->D,1
                 (3'b110) ? 3'b100 :  // D,0->C,0
                 (3'b111) ? 3'b010 :  // D,1->B,0
                 3'b000;              // Default (shouldn't occur)

assign next_state = lut_out[2:1];
assign out = lut_out[0];

endmodule