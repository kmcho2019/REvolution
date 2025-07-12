module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// State encoding parameters
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// LUT for next_state transitions
reg [1:0] state_lut [0:7];  // 8 entries (4 states x 2 inputs)

// Initialize LUT
initial begin
    // Index format: {state[1:0], in}
    state_lut[{A,1'b0}] = A;  // A, in=0 → A
    state_lut[{A,1'b1}] = B;  // A, in=1 → B
    state_lut[{B,1'b0}] = C;  // B, in=0 → C
    state_lut[{B,1'b1}] = B;  // B, in=1 → B
    state_lut[{C,1'b0}] = A;  // C, in=0 → A
    state_lut[{C,1'b1}] = D;  // C, in=1 → D
    state_lut[{D,1'b0}] = C;  // D, in=0 → C
    state_lut[{D,1'b1}] = B;  // D, in=1 → B
end

// State transition logic using LUT
always @(*) begin
    next_state = state_lut[{state, in}];
end

// Output logic - only high in state D
assign out = (state == D);

endmodule