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
// parameter D = 2'b11; // Not explicitly handled

reg [1:0] current_state, next_state;

// Continuous assignment for output g
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0; // g[2] is not explicitly defined in the problem description

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                // This condition handles r[2] = 1 when other requests are not present
                next_state = A; // Stay in A as there's no specific state defined for r[2] = 1 in the problem
            end else begin
                next_state = A; // Stay in A when no requests are present
            end
        end
        B: begin
            if (r[0]) begin
                next_state = B; // Continue granting to device 0
            end else begin
                next_state = A; // Revert to A when device 0's request is removed
            end
        end
        C: begin
            if (r[1]) begin
                next_state = C; // Continue granting to device 1
            end else begin
                next_state = A; // Revert to A when device 1's request is removed
            end
        end
        default: next_state = A; // Default to state A for any other state (including the theoretically unreachable state D)
    endcase
end

endmodule