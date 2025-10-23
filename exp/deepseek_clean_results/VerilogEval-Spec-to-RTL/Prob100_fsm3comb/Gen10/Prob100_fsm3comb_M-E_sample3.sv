module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Combined address for LUT (state + input)
wire [2:0] lut_addr = {state, in};

// LUT implementation for next_state[1]
assign next_state[1] = (lut_addr == 3'b001) |  // B (01) + in=0 -> C (10)
                       (lut_addr == 3'b101) |  // C (10) + in=1 -> D (11)
                       (lut_addr == 3'b110);   // D (11) + in=0 -> C (10)

// LUT implementation for next_state[0]
assign next_state[0] = (lut_addr == 3'b000) |  // A (00) + in=1 -> B (01)
                       (lut_addr == 3'b011) |  // B (01) + in=1 -> B (01)
                       (lut_addr == 3'b101) |  // C (10) + in=1 -> D (11)
                       (lut_addr == 3'b111);   // D (11) + in=1 -> B (01)

// Output is high only in state D (11)
assign out = (state == 2'b11);

endmodule