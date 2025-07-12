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

// State registers
reg [1:0] state, next_state;

// Output logic
always @(*)
begin
    case (state)
        A: g = 3'b000;
        B: g = {2'b00, r[0]};
        C: g = {r[1], 2'b00};
        default: g = 3'b000;
    endcase
end

// Next state logic
always @(*)
begin
    case (state)
        A: 
            if (~r[0] && ~r[1] && ~r[2]) 
                next_state = A;
            else if (r[0]) 
                next_state = B;
            else if (r[1]) 
                next_state = C;
            else 
                next_state = A; // This is for r[2] = 1, but since state D is not used, we go back to A
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

// State flip-flops
always @(posedge clk)
begin
    if (~resetn) 
        state <= A;
    else 
        state <= next_state;
end

endmodule