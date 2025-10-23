module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;  // current state
reg [1:0] next_state;  // next state

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Next state logic
always @(*)
begin
    case (state)
        A:
            if (r[0] == 1'b1)
                next_state = B;
            else if (r[1] == 1'b1)
                next_state = C;
            else if (r[2] == 1'b1)
                next_state = D;
            else
                next_state = A;
        B:
            if (r[0] == 1'b1)
                next_state = B;
            else
                next_state = A;
        C:
            if (r[1] == 1'b1)
                next_state = C;
            else
                next_state = A;
        D:
            // This state is not actually reachable based on the given state diagram
            next_state = A;
        default:
            next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Output logic
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0;  // Since state D is not actually used, we can just set g[2] to 0

endmodule