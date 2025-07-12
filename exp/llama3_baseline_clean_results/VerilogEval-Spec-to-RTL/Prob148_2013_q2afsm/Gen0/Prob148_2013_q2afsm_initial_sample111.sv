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

// State flip-flops
reg [1:0] state;
reg [1:0] next_state;

// Continuous assignment statement for FSM outputs
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0;  // This output is not explicitly described in the problem statement, 
                     // but based on the state diagram, it's clear that g[2] should be 0 in state D.

// State table
always @(*)
begin
    case(state)
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
            next_state = A;  // This state is not reachable based on the state diagram, 
                             // but we need to handle it to avoid a latch.
        default: 
            next_state = A;  // This is to avoid a latch in case of an invalid state.
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

endmodule