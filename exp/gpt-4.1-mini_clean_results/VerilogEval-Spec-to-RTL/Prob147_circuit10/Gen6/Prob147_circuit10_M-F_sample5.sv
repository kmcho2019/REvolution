module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    wire next_state;

    // Next state logic:
    // Hold state when b=0.
    // Set state=1 when b=1, state=0, a=0.
    // Otherwise state=0.
    assign next_state = (state & ~b) | (~state & b & ~a);

    // Output q combinational, depends on current state, a, and b.
    assign q = (state & ~a) | (~state & a & b);

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule