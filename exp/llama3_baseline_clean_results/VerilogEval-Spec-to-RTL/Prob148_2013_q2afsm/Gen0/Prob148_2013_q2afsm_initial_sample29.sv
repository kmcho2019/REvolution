module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State codes
parameter A = 2'b00, B = 2'b01, C = 2'b10;

reg [1:0] state, next_state;

// Continuous assignment for output signals g
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // g[2] is always 0 according to the state diagram

// State table (combinational logic)
always @(*)
begin
    case(state)
        A:
            if (~r[0] && ~r[1] && ~r[2])
                next_state = A;
            else if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else
                next_state = A; // If only r[2] is 1, it has the lowest priority, so it won't get the grant
        B:
            if (r[0])
                next_state = B;
            else
                next_state = A;
        C:
            if (r[1])
                next_state = C;
            else
                next_state = A;
        default:
            next_state = A;
    endcase
end

// State flip-flops (sequential logic)
always @(posedge clk)
begin
    if (~resetn)
        state <= A;
    else
        state <= next_state;
end

endmodule