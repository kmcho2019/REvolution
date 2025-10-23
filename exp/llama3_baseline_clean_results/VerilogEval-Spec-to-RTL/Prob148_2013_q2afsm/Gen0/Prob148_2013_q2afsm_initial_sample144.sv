module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

reg [1:0] state, next_state;

// Continuous assignment for outputs
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // Since there is no state where g2 is 1

// Combinational logic for next state
always @(*)
begin
    case(state)
        A:
            if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else if (r[2])
                // Note: This condition is not specified in the original problem,
                // but based on the state diagram, it should stay in A.
                next_state = A;
            else
                next_state = A;
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

// Sequential logic for state flip-flops
always @(posedge clk)
begin
    if (~resetn)
        state <= A;
    else
        state <= next_state;
end

endmodule