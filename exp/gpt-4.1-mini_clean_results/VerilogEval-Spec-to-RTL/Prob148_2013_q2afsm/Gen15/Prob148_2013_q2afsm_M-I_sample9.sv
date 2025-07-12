module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot encoding of states (4 states)
    // A = 4'b0001 (idle)
    // B = 4'b0010 (grant device 0)
    // C = 4'b0100 (grant device 1)
    // D = 4'b1000 (grant device 2)
    reg [3:0] state, next_state;

    // Synchronous state update with active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001; // state A (idle)
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        // Default next_state to all zeros to avoid latches
        next_state = 4'b0000;

        case (1'b1) // one-hot encoded state decoder (casez alternative)
            state[0]: begin // A (idle)
                // Priority: r[0] > r[1] > r[2]
                if (r[0])
                    next_state = 4'b0010; // B grant device 0
                else if (r[1])
                    next_state = 4'b0100; // C grant device 1
                else if (r[2])
                    next_state = 4'b1000; // D grant device 2
                else
                    next_state = 4'b0001; // remain in A
            end

            state[1]: begin // B grant device 0
                if (r[0])
                    next_state = 4'b0010; // stay in B
                else
                    next_state = 4'b0001; // back to A
            end

            state[2]: begin // C grant device 1
                if (r[1])
                    next_state = 4'b0100; // stay in C
                else
                    next_state = 4'b0001; // back to A
            end

            state[3]: begin // D grant device 2
                if (r[2])
                    next_state = 4'b1000; // stay in D
                else
                    next_state = 4'b0001; // back to A
            end

            default: begin
                next_state = 4'b0001; // default to idle A
            end
        endcase
    end

    // Output logic: grant corresponds directly to states B, C, D
    assign g[0] = state[1]; // grant device 0 in B state
    assign g[1] = state[2]; // grant device 1 in C state
    assign g[2] = state[3]; // grant device 2 in D state

endmodule