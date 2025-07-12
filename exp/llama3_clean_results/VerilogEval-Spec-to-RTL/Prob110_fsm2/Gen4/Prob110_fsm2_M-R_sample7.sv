// Define the states as enumerations
`define OFF 1'b0
`define ON  1'b1

module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

reg state; // current state
reg next_state; // next state

// Asynchronous reset
always @(posedge areset) begin
    state <= `OFF;
end

// Synchronous next-state logic
always @(posedge clk) begin
    if (!areset) begin
        state <= next_state;
    end
end

// Combinational next-state logic
assign next_state = (state == `OFF) ? (j ? `ON : `OFF) : (k ? `OFF : `ON);

// Output logic directly from state
assign out = state;

endmodule