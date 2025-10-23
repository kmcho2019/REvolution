module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output     q
);

wire next_state;

// Next state logic:
// If a=1,b=1 then toggle state
// If a=1,b=0 then reset (0)
// If a=0,b=1 then set (1)
// If a=0,b=0 then hold state
assign next_state = (a & b & ~state)    // toggle when a=1,b=1
                  | (a & ~b & 1'b0)    // reset when a=1,b=0 (0)
                  | (~a & b & 1'b1)    // set when a=0,b=1
                  | (~a & ~b & state); // hold when a=0,b=0

// Output q logic:
// q = state or (when state=0 and inputs a=0,b=1) q=1
assign q = state | (~state & ~a & b);

always @(posedge clk) begin
    state <= next_state;
end

endmodule