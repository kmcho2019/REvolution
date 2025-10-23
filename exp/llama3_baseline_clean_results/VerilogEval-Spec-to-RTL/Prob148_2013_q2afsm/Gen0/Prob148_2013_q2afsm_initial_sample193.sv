module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define states
parameter A = 0;
parameter B = 1;
parameter C = 2;

// State register
reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
assign g = (current_state == B) ? 4'b001 : 
          (current_state == C) ? 4'b010 : 
          3'b000;

// Next state logic
always @(*) begin
    case (current_state)
        A: 
            if (~r[0] && ~r[1] && ~r[2])
                next_state = A;
            else if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
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

// State flip-flop
always @(posedge clk) begin
    if (~resetn)
        current_state <= A;
    else
        current_state <= next_state;
end

endmodule