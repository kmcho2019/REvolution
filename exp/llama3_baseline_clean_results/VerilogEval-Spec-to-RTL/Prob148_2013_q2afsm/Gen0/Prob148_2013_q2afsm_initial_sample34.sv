module TopModule(clk, resetn, r, g);
    input clk;
    input resetn;
    input [2:0] r;
    output [2:0] g;

    reg [1:0] state, next_state;

    // State encoding: A = 2'b00, B = 2'b01, C = 2'b10
    // Continuous assignment for outputs based on states
    assign g[0] = (state == 2'b01); // g0 is 1 in state B
    assign g[1] = (state == 2'b10); // g1 is 1 in state C
    assign g[2] = 0; // g2 is always 0 based on the given state diagram

    // Next state logic
    always @(*) begin
        case(state)
            2'b00: // State A
                if (~r[0] && r[1]) begin
                    next_state = 2'b10; // Go to state C if r1 is 1 and r0 is 0
                end else if (r[0]) begin
                    next_state = 2'b01; // Go to state B if r0 is 1
                end else if (~r[0] && ~r[1] && r[2]) begin
                    // This condition is not explicitly handled as a separate state in the FSM
                    // Since the priority is handled in the next_state logic, we don't need a separate state for D
                    next_state = 2'b00; // Stay in A if only r2 is 1
                end else begin
                    next_state = 2'b00; // Stay in A if no requests
                end
            2'b01: // State B
                if (r[0]) begin
                    next_state = 2'b01; // Stay in B if r0 is still 1
                end else begin
                    next_state = 2'b00; // Go back to A if r0 is 0
                end
            2'b10: // State C
                if (r[1]) begin
                    next_state = 2'b10; // Stay in C if r1 is still 1
                end else begin
                    next_state = 2'b00; // Go back to A if r1 is 0
                end
            default: next_state = 2'b00; // Handle any other state (including 2'b11) as going back to A
        endcase
    end

    // State flip-flops
    always @(posedge clk) begin
        if (~resetn) begin
            state <= 2'b00; // Reset to state A
        end else begin
            state <= next_state;
        end
    end
endmodule