module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg [1:0] state; // {q, p}
reg [1:0] next_state;

assign q = state[1];
assign p = state[0];

// Next state logic combinational block
always @(*) begin
    // Default next state is current state (hold)
    next_state = state;

    // Implement next state logic similar to the original approach:
    // next p = (a & ~q) | (p & q)
    // next q = p | q
    // where state = {q, p}
    next_state[0] = (a & ~state[1]) | (state[0] & state[1]); // next p
    next_state[1] = state[0] | state[1];                     // next q
end

// State register update on posedge clock
always @(posedge clock) begin
    state <= next_state;
end

// Initial state undefined to match x at startup (simulation)
endmodule