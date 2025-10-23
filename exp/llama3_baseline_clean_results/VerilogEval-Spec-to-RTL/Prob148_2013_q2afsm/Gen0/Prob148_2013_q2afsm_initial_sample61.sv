module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;

// Declare current and next state
reg [2:0] current_state;
reg [2:0] next_state;

// State table
always @(*)
begin
    case (current_state)
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
            next_state = A;
        default:
            next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (~resetn)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output assignments
assign g[0] = (current_state == B) ? 1'b1 : 1'b0;
assign g[1] = (current_state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // No state sets g[2] to 1

endmodule