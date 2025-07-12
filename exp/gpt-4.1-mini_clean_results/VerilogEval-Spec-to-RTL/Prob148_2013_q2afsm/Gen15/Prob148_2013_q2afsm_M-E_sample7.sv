module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    // State A = 4'b0001 (idle)
    // State B = 4'b0010 (grant device 0)
    // State C = 4'b0100 (grant device 1)
    // State D = 4'b1000 (grant device 2)
    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001; // Reset to state A
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (1'b1)
            state[0]: begin // State A
                if (r[0])
                    next_state = 4'b0010; // B
                else if (r[1])
                    next_state = 4'b0100; // C
                else if (r[2])
                    next_state = 4'b1000; // D
                else
                    next_state = 4'b0001; // Stay in A
            end

            state[1]: begin // State B (grant 0)
                next_state = r[0] ? 4'b0010 : 4'b0001; // Stay if r0=1 else A
            end

            state[2]: begin // State C (grant 1)
                next_state = r[1] ? 4'b0100 : 4'b0001; // Stay if r1=1 else A
            end

            state[3]: begin // State D (grant 2)
                next_state = r[2] ? 4'b1000 : 4'b0001; // Stay if r2=1 else A
            end

            default: next_state = 4'b0001; // Safety fallback to A
        endcase
    end

    // Output logic directly from one-hot state bits
    assign g[0] = state[1]; // grant device 0 when in state B
    assign g[1] = state[2]; // grant device 1 when in state C
    assign g[2] = state[3]; // grant device 2 when in state D

endmodule