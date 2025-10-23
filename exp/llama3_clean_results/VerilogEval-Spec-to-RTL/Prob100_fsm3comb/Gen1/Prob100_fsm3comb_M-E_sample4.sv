module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

reg [1:0] next_state;
reg out;

// State transition table encoded as a lookup table
parameter next_state_table [3:0][1:0] = {
    {2'b00, 2'b01},  // State A
    {2'b10, 2'b01},  // State B
    {2'b00, 2'b11},  // State C
    {2'b10, 2'b01}   // State D
};

// Output table encoded as a lookup table
parameter output_table [3:0] = {
    1'b0,  // State A
    1'b0,  // State B
    1'b0,  // State C
    1'b1   // State D
};

always @(*) begin
    // Determine the index into the lookup tables
    integer idx;
    case(state)
        2'b00: idx = 0;  // State A
        2'b01: idx = 1;  // State B
        2'b10: idx = 2;  // State C
        2'b11: idx = 3;  // State D
    endcase

    // Determine the next state based on the current state and input
    if (!in) begin
        next_state = next_state_table[idx][1:0];
    end else begin
        next_state = next_state_table[idx][1:0] + 1;
    end

    // Determine the output based on the current state
    out = output_table[idx];
end

endmodule