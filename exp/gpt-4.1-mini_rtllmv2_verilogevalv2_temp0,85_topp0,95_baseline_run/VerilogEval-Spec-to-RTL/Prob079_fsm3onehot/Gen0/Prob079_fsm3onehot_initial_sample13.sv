module TopModule(
    input  wire        in,
    input  wire [3:0]  state,
    output wire [3:0]  next_state,
    output wire        out
);

// State encoding
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// Next state logic (one-hot)
assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);        // A: from A(in=0) or C(in=0)
assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in); // B: from A(in=1), B(in=1), D(in=1)
assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);       // C: from B(in=0), D(in=0)
assign next_state[3] = (state[2] & in);                           // D: from C(in=1)

// Output logic: only high in state D
assign out = state[3];

endmodule