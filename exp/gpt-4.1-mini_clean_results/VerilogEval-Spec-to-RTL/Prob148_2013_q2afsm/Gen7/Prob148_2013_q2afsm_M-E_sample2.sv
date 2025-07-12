module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot encoded states
    localparam A = 3'b001,
               B = 3'b010,
               C = 3'b100;
    // State D will be encoded implicitly as no grant state when r2 alone requests
    // Instead, we use a fourth bit for D to keep consistent one-hot encoding
    localparam D = 3'b000; // Will use separate reg for state bits including D

    reg [3:0] state, next_state;

    // Assign one-hot codes:
    // state[0] = A
    // state[1] = B
    // state[2] = C
    // state[3] = D

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001; // A state active
        else
            state <= next_state;
    end

    // Next-state logic: priority-based arbiter and self-loop checks
    always @(*) begin
        // default no state
        next_state = 4'b0000;
        case (1'b1) // priority encoding of current state (one-hot)
            state[0]: begin // A
                // Priority: r0 > r1 > r2
                if (r[0])
                    next_state = 4'b0010; // B
                else if (r[1])
                    next_state = 4'b0100; // C
                else if (r[2])
                    next_state = 4'b1000; // D
                else
                    next_state = 4'b0001; // stay A
            end
            state[1]: begin // B, grant device 0
                if (r[0])
                    next_state = 4'b0010; // stay B
                else
                    next_state = 4'b0001; // back to A
            end
            state[2]: begin // C, grant device 1
                if (r[1])
                    next_state = 4'b0100; // stay C
                else
                    next_state = 4'b0001; // back to A
            end
            state[3]: begin // D, grant device 2
                if (r[2])
                    next_state = 4'b1000; // stay D
                else
                    next_state = 4'b0001; // back to A
            end
            default: next_state = 4'b0001; // Reset to A if invalid
        endcase
    end

    // Output logic: grant outputs based on current state bits
    assign g = {state[3], state[2], state[1]};

endmodule