module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

    // One-hot state encoding:
    // state[0] = A (idle)
    // state[1] = B (grant device 0)
    // state[2] = C (grant device 1)
    // state[3] = D (grant device 2)
    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001;  // Reset to A (state[0]=1)
        else
            state <= next_state;
    end

    // Next-state logic (combinational)
    always @(*) begin
        // Default next state is 0 for all bits
        next_state = 4'b0000;

        casez (state)
            4'b0001: begin // A
                // Priority: r[0] > r[1] > r[2]
                if (r[0])
                    next_state = 4'b0010; // B
                else if (r[1])
                    next_state = 4'b0100; // C
                else if (r[2])
                    next_state = 4'b1000; // D
                else
                    next_state = 4'b0001; // stay in A
            end
            4'b0010: begin // B (grant device 0)
                next_state = r[0] ? 4'b0010 : 4'b0001;
            end
            4'b0100: begin // C (grant device 1)
                next_state = r[1] ? 4'b0100 : 4'b0001;
            end
            4'b1000: begin // D (grant device 2)
                next_state = r[2] ? 4'b1000 : 4'b0001;
            end
            default: begin
                next_state = 4'b0001; // Recover to A if invalid
            end
        endcase
    end

    // Output logic: grant signals directly map to states B, C, D
    assign g[0] = state[1]; // grant device 0
    assign g[1] = state[2]; // grant device 1
    assign g[2] = state[3]; // grant device 2

endmodule