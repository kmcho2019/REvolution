module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Packed LUT for next states (4 states × 2 inputs = 8 entries × 2 bits)
// Format: {in=1,in=0} for states D,C,B,A
localparam [15:0] NEXT_STATE_LUT = {
    /* D in=1 */ 2'b01, /* D in=0 */ 2'b10,
    /* C in=1 */ 2'b11, /* C in=0 */ 2'b00,
    /* B in=1 */ 2'b01, /* B in=0 */ 2'b10,
    /* A in=1 */ 2'b01, /* A in=0 */ 2'b00
};

// Packed LUT for outputs (only depends on state)
localparam [3:0] OUTPUT_LUT = {
    /* D */ 1'b1,
    /* C */ 1'b0,
    /* B */ 1'b0,
    /* A */ 1'b0
};

wire [2:0] lut_addr = {state, in};

assign next_state = NEXT_STATE_LUT[{lut_addr, 1'b1} -: 2];
assign out = OUTPUT_LUT[state];

endmodule