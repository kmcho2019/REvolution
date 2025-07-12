module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoding for states (6 states)
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic using one-hot encoding
    always @(*) begin
        // default next_state is zero to avoid latches
        next_state = 6'b000000;

        case (1'b1) // priority encoding for one-hot states
            state[0]: // A
                if (w == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            state[1]: // B
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            state[2]: // C
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            state[3]: // D
                if (w == 1'b0)
                    next_state = F;
                else
                    next_state = A;
            state[4]: // E
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            state[5]: // F
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            default: // for safety, if no state active, go to A
                next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z is 1 when in E or F
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule