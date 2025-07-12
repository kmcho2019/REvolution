module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    // state[0] = A
    // state[1] = B
    // state[2] = C
    // state[3] = D
    // state[4] = E
    // state[5] = F

    reg [5:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        // default no state active
        next_state = 6'b000000;

        casez(state)
            6'b000001: begin // A
                if (w == 1'b0) next_state = 6'b000010; // B
                else           next_state = 6'b000001; // A
            end
            6'b000010: begin // B
                if (w == 1'b0) next_state = 6'b000100; // C
                else           next_state = 6'b001000; // D
            end
            6'b000100: begin // C
                if (w == 1'b0) next_state = 6'b010000; // E
                else           next_state = 6'b001000; // D
            end
            6'b001000: begin // D
                if (w == 1'b0) next_state = 6'b100000; // F
                else           next_state = 6'b000001; // A
            end
            6'b010000: begin // E
                if (w == 1'b0) next_state = 6'b010000; // E
                else           next_state = 6'b001000; // D
            end
            6'b100000: begin // F
                if (w == 1'b0) next_state = 6'b000100; // C
                else           next_state = 6'b001000; // D
            end
            default: next_state = 6'b000001; // default to A
        endcase
    end

    // State flip-flops with reset
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // A
        else
            state <= next_state;
    end

    // Output z is 1 if in state E or F
    always @(*) begin
        z = state[4] | state[5];
    end

endmodule