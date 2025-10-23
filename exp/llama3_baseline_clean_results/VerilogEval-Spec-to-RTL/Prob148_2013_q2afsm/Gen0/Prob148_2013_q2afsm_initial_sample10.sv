module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// State table
always @(*)
begin
    case (state)
        A:
            if (r[0] == 1)
                next_state = B;
            else if (r[1] == 1)
                next_state = C;
            else if (r[2] == 1)
                next_state = D;
            else
                next_state = A;
        B:
            if (r[0] == 1)
                next_state = B;
            else
                next_state = A;
        C:
            if (r[1] == 1)
                next_state = C;
            else
                next_state = A;
        D:
            next_state = A; // Not actually used in the given FSM, but added for completeness
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
assign g[2] = 1'b0; // Since state D is not actually used in the given FSM

endmodule