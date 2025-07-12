module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Continuous assignment for output signals g
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 0;

// Next state logic
always @(*)
begin
    case(current_state)
        A:
            if(r[0] == 1)
                next_state = B;
            else if(r[1] == 1)
                next_state = C;
            else
                next_state = A;
        B:
            if(r[0] == 1)
                next_state = B;
            else
                next_state = A;
        C:
            if(r[1] == 1)
                next_state = C;
            else
                next_state = A;
        default:
            next_state = A;
    endcase

    // Reset logic
    if(~resetn)
        next_state = A;
end

// State flip-flops
always @(posedge clk)
begin
    current_state <= next_state;
end

endmodule