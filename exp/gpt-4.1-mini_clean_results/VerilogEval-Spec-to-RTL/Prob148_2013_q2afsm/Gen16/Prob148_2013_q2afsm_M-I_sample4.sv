module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

    // One-hot state encoding: 4 bits for states A, B, C, D
    // A = 4'b0001 (idle)
    // B = 4'b0010 (grant device 0)
    // C = 4'b0100 (grant device 1)
    // D = 4'b1000 (grant device 2)
    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001;  // Reset to A (idle)
        else
            state <= next_state;
    end

    // Next-state logic (combinational)
    always @(*) begin
        // default to all zeros to catch unintended latches
        next_state = 4'b0000;
        casez(state)
            4'b0001: begin // A: idle state
                if (r[0])      next_state = 4'b0010; // B: grant device 0
                else if (r[1]) next_state = 4'b0100; // C: grant device 1
                else if (r[2]) next_state = 4'b1000; // D: grant device 2
                else           next_state = 4'b0001; // stay in A
            end

            4'b0010: begin // B: grant device 0
                if (r[0]) next_state = 4'b0010;  // stay B if request 0 continues
                else      next_state = 4'b0001;  // else back to A
            end

            4'b0100: begin // C: grant device 1
                if (r[1]) next_state = 4'b0100;  // stay C if request 1 continues
                else      next_state = 4'b0001;  // else back to A
            end

            4'b1000: begin // D: grant device 2
                if (r[2]) next_state = 4'b1000;  // stay D if request 2 continues
                else      next_state = 4'b0001;  // else back to A
            end

            default: next_state = 4'b0001; // safety fallback to A
        endcase
    end

    // Output grant signals derived directly from one-hot state bits
    assign g[0] = state[1]; // B state: grant device 0
    assign g[1] = state[2]; // C state: grant device 1
    assign g[2] = state[3]; // D state: grant device 2

endmodule