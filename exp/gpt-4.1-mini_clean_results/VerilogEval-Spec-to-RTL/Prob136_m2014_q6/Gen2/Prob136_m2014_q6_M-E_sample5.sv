module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    // One-hot state encoding: 6 bits, one per state
    // state[0] = A, state[1] = B, ..., state[5] = F
    reg [5:0] state, next_state;

    // Next state logic: combinational
    always @(*) begin
        next_state = 6'b0; // default no state

        case (1'b1)
            state[0]: // A
                if (w == 1'b0)
                    next_state[1] = 1'b1; // B
                else
                    next_state[0] = 1'b1; // A

            state[1]: // B
                if (w == 1'b0)
                    next_state[2] = 1'b1; // C
                else
                    next_state[3] = 1'b1; // D

            state[2]: // C
                if (w == 1'b0)
                    next_state[4] = 1'b1; // E
                else
                    next_state[3] = 1'b1; // D

            state[3]: // D
                if (w == 1'b0)
                    next_state[5] = 1'b1; // F
                else
                    next_state[0] = 1'b1; // A

            state[4]: // E
                if (w == 1'b0)
                    next_state[4] = 1'b1; // E
                else
                    next_state[3] = 1'b1; // D

            state[5]: // F
                if (w == 1'b0)
                    next_state[2] = 1'b1; // C
                else
                    next_state[3] = 1'b1; // D

            default:
                next_state[0] = 1'b1; // default to A if no state active
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // state A active
        else
            state <= next_state;
    end

    // Output logic: z = 1 if state E or F active
    always @(*) begin
        z = state[4] | state[5];
    end

endmodule