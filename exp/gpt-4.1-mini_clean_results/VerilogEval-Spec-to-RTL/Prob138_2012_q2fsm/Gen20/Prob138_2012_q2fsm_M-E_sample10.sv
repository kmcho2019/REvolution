module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (1'b1) // one-hot case statement
            state[0]: // A
                if (w)
                    next_state = B;
                else
                    next_state = A;
            state[1]: // B
                if (w)
                    next_state = C;
                else
                    next_state = D;
            state[2]: // C
                if (w)
                    next_state = E;
                else
                    next_state = D;
            state[3]: // D
                if (w)
                    next_state = F;
                else
                    next_state = A;
            state[4]: // E
                if (w)
                    next_state = E;
                else
                    next_state = D;
            state[5]: // F
                if (w)
                    next_state = C;
                else
                    next_state = D;
            default: next_state = A; // safety fallback
        endcase
    end

    // Output logic: z=1 for states E or F
    assign z = state[4] | state[5];

endmodule