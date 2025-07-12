module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic: combinational, based on current one-hot state and input w
    always @(*) begin
        // Default next state: none
        next_state = 6'b000000;

        case (1'b1) // case on one-hot active bit
            state[0]: begin // A
                if (w == 1'b0) next_state = B;
                else           next_state = A;
            end
            state[1]: begin // B
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            state[2]: begin // C
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            state[3]: begin // D
                if (w == 1'b0) next_state = F;
                else           next_state = A;
            end
            state[4]: begin // E
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            state[5]: begin // F
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            default: next_state = A; // default to A if no valid state
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A; // start in state A
        else
            state <= next_state;
    end

    // Output logic: z=1 if in state E or F
    always @(*) begin
        z = state[4] | state[5];
    end

endmodule