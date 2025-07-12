module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// One-hot encoded states
localparam S0 = 5'b00001; // no match
localparam S1 = 5'b00010; // matched '1'
localparam S2 = 5'b00100; // matched "11"
localparam S3 = 5'b01000; // matched "110"
localparam S4 = 5'b10000; // matched "1101" (final)

// State register: one-hot encoded (5 bits)
reg [4:0] state, next_state;

// Synchronous state update with active-high synchronous reset
always @(posedge clk) begin
    if (reset)
        state <= S0;
    else
        state <= next_state;
end

// Next-state combinational logic
always @(*) begin
    // Default hold
    next_state = 5'b00000;
    case (1'b1) // synthesis parallel_case full_case
        state[0]: next_state = data ? S1 : S0;     // S0
        state[1]: next_state = data ? S2 : S0;     // S1
        state[2]: next_state = data ? S2 : S3;     // S2
        state[3]: next_state = data ? S4 : S0;     // S3
        state[4]: next_state = S4;                  // S4 (latched detected)
        default: next_state = S0;
    endcase
end

// Output asserted when detected state (S4) is active, held high thereafter
assign start_shifting = state[4];

endmodule