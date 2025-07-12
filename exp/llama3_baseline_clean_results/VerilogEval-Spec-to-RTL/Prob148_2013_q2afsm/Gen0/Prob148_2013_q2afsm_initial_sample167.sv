module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10
reg [1:0] current_state, next_state;

// Continuous assignment for outputs
assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = 1'b0;  // Since state D is not actually reachable

// Next state logic
always @(*) begin
    case (current_state)
        2'b00: begin  // State A
            if (r[0]) begin
                next_state = 2'b01;  // Transition to state B
            end else if (r[1]) begin
                next_state = 2'b10;  // Transition to state C
            end else if (r[2]) begin
                // Although the state diagram does not explicitly show a transition from A to D, 
                // based on the given description and problem constraints, it seems D should be considered
                // as an unreachable state in this implementation context.
                // For consistency with the provided state diagram, we transition to A if only r[2] is high.
                next_state = 2'b00;  
            end else begin
                next_state = 2'b00;  // Stay in state A
            end
        end
        2'b01: begin  // State B
            if (r[0]) begin
                next_state = 2'b01;  // Stay in state B
            end else begin
                next_state = 2'b00;  // Transition to state A
            end
        end
        2'b10: begin  // State C
            if (r[1]) begin
                next_state = 2'b10;  // Stay in state C
            end else begin
                next_state = 2'b00;  // Transition to state A
            end
        end
        default: next_state = 2'b00;  // Default to state A for any other state
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00;  // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

endmodule