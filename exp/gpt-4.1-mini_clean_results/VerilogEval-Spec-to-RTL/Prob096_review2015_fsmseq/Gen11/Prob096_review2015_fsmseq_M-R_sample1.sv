module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// One-hot state encoding
localparam S0 = 5'b00001; // no match
localparam S1 = 5'b00010; // matched '1'
localparam S2 = 5'b00100; // matched "11"
localparam S3 = 5'b01000; // matched "110"
localparam S4 = 5'b10000; // matched "1101" (final)

// State register
reg [4:0] state, next_state;

// Next state combinational logic (one-hot style)
wire next_S0, next_S1, next_S2, next_S3, next_S4;

// Derive next state signals from current state and input data
assign next_S0 = (state == S0 && !data) ||
                 (state == S1 && !data) ||
                 (state == S3 && !data) ||
                 (state == S4) ||
                 (state == S0 && data && 1'b0) || // no other condition to S0 for data=1 here
                 (state == S2 && 1'b0); // default no transition here
                 
assign next_S1 = (state == S0 && data) ||
                 (state == S4 && 1'b0); // hold S4 state, no transition back here

assign next_S2 = (state == S1 && data) ||
                 (state == S2 && data);

assign next_S3 = (state == S2 && !data);

assign next_S4 = (state == S3 && data) ||
                 (state == S4); // latch final state

// Since above expressions for next_S0 are not entirely correct logically,
// rewrite next state logic precisely matching original FSM transitions:

// Corrected next state logic with one-hot signals:
assign next_S0 =
    (state == S0 && !data) ||
    (state == S1 && !data) ||
    (state == S3 && !data);

assign next_S1 =
    (state == S0 && data);

assign next_S2 =
    (state == S1 && data) ||
    (state == S2 && data);

assign next_S3 =
    (state == S2 && !data);

assign next_S4 =
    (state == S3 && data) ||
    (state == S4); // latch in final state

// Assemble next_state vector from next_Sx
always @(*) begin
    next_state = 5'b00000;
    if (next_S0) next_state = S0;
    else if (next_S1) next_state = S1;
    else if (next_S2) next_state = S2;
    else if (next_S3) next_state = S3;
    else if (next_S4) next_state = S4;
    else next_state = S0; // default safe state
end

// State update with synchronous reset
always @(posedge clk) begin
    if (reset)
        state <= S0;
    else
        state <= next_state;
end

// Output asserted when in S4 final matched state
assign start_shifting = (state == S4);

endmodule