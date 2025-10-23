module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] current_state;
reg [1:0] next_state;

// Continuous assignment for outputs
assign g[0] = (current_state == B) ? 1'b1 : 1'b0;
assign g[1] = (current_state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // g[2] is never 1 in this FSM

// State table
always @(posedge clk)
begin
    if (!resetn)
        next_state <= A;
    else
    begin
        case (current_state)
            A:
                if (r[0] == 1'b1)
                    next_state <= B;
                else if (r[1] == 1'b1)
                    next_state <= C;
                else if (r[2] == 1'b1)
                    next_state <= D;
                else
                    next_state <= A;
            B:
                if (r[0] == 1'b1)
                    next_state <= B;
                else
                    next_state <= A;
            C:
                if (r[1] == 1'b1)
                    next_state <= C;
                else
                    next_state <= A;
            D:
                // This state is not actually needed in this FSM
                // But we keep it here to make the code more complete
                next_state <= A;
            default:
                next_state <= A;
        endcase
    end
end

// State flip-flops
always @(posedge clk)
begin
    if (!resetn)
        current_state <= A;
    else
        current_state <= next_state;
end

endmodule