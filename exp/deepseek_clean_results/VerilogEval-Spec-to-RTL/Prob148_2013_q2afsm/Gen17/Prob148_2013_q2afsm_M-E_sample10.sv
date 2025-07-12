module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: Each bit represents an active grant
    // [2] = g2, [1] = g1, [0] = g0
    reg [2:0] state;

    // Outputs directly driven by state bits
    assign g = state;

    // State transitions
    always @(posedge clk) begin
        if (!resetn) begin
            state <= 3'b000;  // Reset to state A
        end else begin
            case (1'b1)
                // If in state A (no grants)
                (state == 3'b000): begin
                    // Priority encoder with parallel evaluation
                    state <= {r[2] & ~(r[1] | r[0]),  // g2 if only r2
                              r[1] & ~r[0],           // g1 if r1 and not r0
                              r[0]};                  // g0 if r0 (highest priority)
                end
                
                // If in state B (g0 active)
                state[0]: state <= {2'b00, r[0]};
                
                // If in state C (g1 active)
                state[1]: state <= {1'b0, r[1], 1'b0};
                
                // If in state D (g2 active)
                state[2]: state <= {r[2], 2'b00};
            endcase
        end
    end

endmodule