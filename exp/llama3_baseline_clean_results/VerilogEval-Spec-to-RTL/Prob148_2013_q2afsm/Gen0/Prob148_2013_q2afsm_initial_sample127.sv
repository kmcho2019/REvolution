module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Continuous assignment for output logic
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 0; // Device 2 will only receive a grant when it is the only device making a request, but based on the state diagram, there is no state where g2 is 1.

// Combinational logic for next state
always @(*) begin
    case(current_state)
        A: 
            if (~r[0] && ~r[1] && ~r[2]) 
                next_state = A;
            else if (r[0]) 
                next_state = B;
            else if (r[1]) 
                next_state = C;
            else if (r[2]) 
                next_state = D;
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
        D: 
            next_state = A; // Based on the given state diagram, there is no condition to stay in state D, so we always go back to state A.
        default: 
            next_state = A;
    endcase
end

// Sequential logic for state flip-flops
always @(posedge clk) begin
    if (~resetn) 
        current_state <= A;
    else 
        current_state <= next_state;
end

endmodule