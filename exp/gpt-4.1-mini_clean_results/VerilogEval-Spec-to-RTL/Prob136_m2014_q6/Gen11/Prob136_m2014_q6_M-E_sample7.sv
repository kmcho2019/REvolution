module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding for states:
    // A = 6'b000001, B = 6'b000010, C = 6'b000100,
    // D = 6'b001000, E = 6'b010000, F = 6'b100000
    reg [5:0] state, next_state;

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // State A
        else
            state <= next_state;
    end

    // Combinational next state logic
    always @(*) begin
        next_state = 6'b000000; // default none active
        case (state)
            6'b000001: // A
                if (w == 1'b0)
                    next_state = 6'b000010; // B
                else
                    next_state = 6'b000001; // A
            6'b000010: // B
                if (w == 1'b0)
                    next_state = 6'b000100; // C
                else
                    next_state = 6'b001000; // D
            6'b000100: // C
                if (w == 1'b0)
                    next_state = 6'b010000; // E
                else
                    next_state = 6'b001000; // D
            6'b001000: // D
                if (w == 1'b0)
                    next_state = 6'b100000; // F
                else
                    next_state = 6'b000001; // A
            6'b010000: // E
                if (w == 1'b0)
                    next_state = 6'b010000; // E
                else
                    next_state = 6'b001000; // D
            6'b100000: // F
                if (w == 1'b0)
                    next_state = 6'b000100; // C
                else
                    next_state = 6'b001000; // D
            default:
                next_state = 6'b000001; // default reset to A if invalid state
        endcase
    end

    // Output logic: z=1 when in state E or F
    assign z = (state[4] /* E */) | (state[5] /* F */);

endmodule