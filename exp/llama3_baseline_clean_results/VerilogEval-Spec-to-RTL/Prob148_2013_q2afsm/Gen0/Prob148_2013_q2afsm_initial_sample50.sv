module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define states
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Declare registers for current state and next state
reg [1:0] curr_state, next_state;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        curr_state <= A;
    end else begin
        curr_state <= next_state;
    end
end

// State table
always @(*) begin
    case (curr_state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0]) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1]) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        D: begin
            // As per the problem description, state D does not have any outgoing transitions.
            // However, in the given state diagram, it seems like D should behave like A.
            // So, we are assuming that D should behave like A.
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        default: next_state = A;
    endcase
end

// Output logic
assign g[0] = (curr_state == B);
assign g[1] = (curr_state == C);
assign g[2] = 0;  // Since there is no transition to set g[2] to 1

endmodule