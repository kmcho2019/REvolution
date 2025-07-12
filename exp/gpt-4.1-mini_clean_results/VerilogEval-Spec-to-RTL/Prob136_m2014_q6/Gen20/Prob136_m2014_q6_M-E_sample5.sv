module TopModule (
    input        clk,
    input        reset,
    input        w,
    output reg   z
);

    // One-hot state encoding: each bit represents a state
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic: case on current state
    always @(*) begin
        next_state = 6'b0; // default to none active
        case (state)
            A: if (w == 1'b0) next_state = B; else next_state = A;
            B: if (w == 1'b0) next_state = C; else next_state = D;
            C: if (w == 1'b0) next_state = E; else next_state = D;
            D: if (w == 1'b0) next_state = F; else next_state = A;
            E: if (w == 1'b0) next_state = E; else next_state = D;
            F: if (w == 1'b0) next_state = C; else next_state = D;
            default: next_state = A; // safety fallback
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z=1 in states E or F, else 0
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule