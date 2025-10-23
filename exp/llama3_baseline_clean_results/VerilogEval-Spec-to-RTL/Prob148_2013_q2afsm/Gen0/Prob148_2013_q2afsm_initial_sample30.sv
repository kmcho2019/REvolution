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
parameter D = 2'b11;

// Define current and next state variables
reg [1:0] current_state, next_state;

// Continuous assignment for output values (g)
assign g[0] = (current_state == B) ? 1'b1 : 1'b0;
assign g[1] = (current_state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0;  // g[2] is not used in the given FSM

// State table
always @(*) begin
    case (current_state)
        A: begin
            if (~r[0] && ~r[1] && ~r[2])
                next_state = A;
            else if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        B: begin
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn)
        current_state <= A;
    else
        current_state <= next_state;
end

endmodule