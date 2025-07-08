module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

// Decode current states for clarity
wire S0 = state[0];
wire S1 = state[1];
wire S2 = state[2];
wire S3 = state[3];
wire S4 = state[4];
wire S5 = state[5];
wire S6 = state[6];
wire S7 = state[7];
wire S8 = state[8];
wire S9 = state[9];

// Next state bits
// Initialize all next_state bits to zero, then OR the contributions from all active states

// From S0
wire [9:0] next_from_S0 = in ? 10'b0000000010 : 10'b0000000001; // in=1->S1, in=0->S0

// From S1
wire [9:0] next_from_S1 = in ? 10'b0000000100 : 10'b0000000001; // in=1->S2, in=0->S0

// From S2
wire [9:0] next_from_S2 = in ? 10'b0000001000 : 10'b0000000001; // in=1->S3, in=0->S0

// From S3
wire [9:0] next_from_S3 = in ? 10'b0000010000 : 10'b0000000001; // in=1->S4, in=0->S0

// From S4
wire [9:0] next_from_S4 = in ? 10'b0000100000 : 10'b0000000001; // in=1->S5, in=0->S0

// From S5
wire [9:0] next_from_S5 = in ? 10'b0000010000_00000000 >> (10-7) : 10'b0000010000_00000000 >> (10-8); 
// Let's be explicit:
// in=1->S6 (bit 6), in=0->S8 (bit 8)
wire [9:0] next_from_S5_explicit = in ? 10'b0000001000000 >> (10-7) : 10'b0000010000000 >> (10-8);
// Correcting: bit 6 is 10'b0000001000000 = 10'b0000001000000 (bit 6 = 1)
// bit 8 is 10'b1000000000
// So:
wire [9:0] next_from_S5_final = in ? 10'b0000001000000 >> 0 : 10'b1000000000 >> 0;
// Simplify:
wire [9:0] next_from_S5_final2 = in ? (1 << 6) : (1 << 8);

// From S6
// in=1->S7 (bit 7), in=0->S9 (bit 9)
wire [9:0] next_from_S6 = in ? (1 << 7) : (1 << 9);

// From S7
// in=0->S0, in=1->S7 (self loop)
wire [9:0] next_from_S7 = in ? (1 << 7) : (1 << 0);

// From S8
// in=0->S0, in=1->S1
wire [9:0] next_from_S8 = in ? (1 << 1) : (1 << 0);

// From S9
// in=0->S0, in=1->S1
wire [9:0] next_from_S9 = in ? (1 << 1) : (1 << 0);

// Combine all next states based on current active states
assign next_state = 
    (S0 ? next_from_S0 : 0) |
    (S1 ? next_from_S1 : 0) |
    (S2 ? next_from_S2 : 0) |
    (S3 ? next_from_S3 : 0) |
    (S4 ? next_from_S4 : 0) |
    (S5 ? next_from_S5_final2 : 0) |
    (S6 ? next_from_S6 : 0) |
    (S7 ? next_from_S7 : 0) |
    (S8 ? next_from_S8 : 0) |
    (S9 ? next_from_S9 : 0);

// Output logic
// Out1 is 1 in S8 and S9 states
assign out1 = S8 | S9;
// Out2 is 1 in S7 and S9 states
assign out2 = S7 | S9;

endmodule