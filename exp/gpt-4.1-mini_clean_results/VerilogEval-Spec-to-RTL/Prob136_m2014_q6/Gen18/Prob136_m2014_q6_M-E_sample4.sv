module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding: 6 bits for 6 states
    // Bit positions: A=0, B=1, C=2, D=3, E=4, F=5
    reg [5:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        next_state = 6'b0; // default no state
        case (1'b1)
            state[0]: begin // A
                if (w == 1'b0) next_state[1] = 1'b1; // B
                else next_state[0] = 1'b1;           // A
            end
            state[1]: begin // B
                if (w == 1'b0) next_state[2] = 1'b1; // C
                else next_state[3] = 1'b1;           // D
            end
            state[2]: begin // C
                if (w == 1'b0) next_state[4] = 1'b1; // E
                else next_state[3] = 1'b1;           // D
            end
            state[3]: begin // D
                if (w == 1'b0) next_state[5] = 1'b1; // F
                else next_state[0] = 1'b1;           // A
            end
            state[4]: begin // E
                if (w == 1'b0) next_state[4] = 1'b1; // E
                else next_state[3] = 1'b1;           // D
            end
            state[5]: begin // F
                if (w == 1'b0) next_state[2] = 1'b1; // C
                else next_state[3] = 1'b1;           // D
            end
            default: next_state[0] = 1'b1; // default to A
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // A state active
        else
            state <= next_state;
    end

    // Output logic: z=1 in E or F states, else 0
    always @(*) begin
        z = state[4] | state[5];
    end

endmodule