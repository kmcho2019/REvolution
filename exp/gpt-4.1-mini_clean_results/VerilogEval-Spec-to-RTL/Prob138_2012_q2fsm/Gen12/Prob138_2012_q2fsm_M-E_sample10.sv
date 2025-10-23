module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding (6 states)
    // A = 6'b000001, B = 6'b000010, C = 6'b000100, D = 6'b001000, E = 6'b010000, F = 6'b100000
    reg [5:0] state, next_state;

    // State flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // state A
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        // Default next_state to zero to avoid latches
        next_state = 6'b000000;
        case (1'b1)
            state[0]: begin // A
                if (w)
                    next_state = 6'b000010; // B
                else
                    next_state = 6'b000001; // A
            end
            state[1]: begin // B
                if (w)
                    next_state = 6'b000100; // C
                else
                    next_state = 6'b001000; // D
            end
            state[2]: begin // C
                if (w)
                    next_state = 6'b010000; // E
                else
                    next_state = 6'b001000; // D
            end
            state[3]: begin // D
                if (w)
                    next_state = 6'b100000; // F
                else
                    next_state = 6'b000001; // A
            end
            state[4]: begin // E
                if (w)
                    next_state = 6'b010000; // E
                else
                    next_state = 6'b001000; // D
            end
            state[5]: begin // F
                if (w)
                    next_state = 6'b000100; // C
                else
                    next_state = 6'b001000; // D
            end
            default: next_state = 6'b000001; // Reset to A on invalid state
        endcase
    end

    // Output logic: z=1 when in states E or F
    assign z = state[4] | state[5];

endmodule