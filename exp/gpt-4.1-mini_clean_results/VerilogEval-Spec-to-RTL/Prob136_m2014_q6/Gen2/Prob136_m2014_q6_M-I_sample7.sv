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

    // Next state logic with one-hot encoding
    always @(*) begin
        // Default no change
        next_state = A;

        case (1'b1)
            state[A]: next_state = (w == 1'b0) ? B : A;
            state[B]: next_state = (w == 1'b0) ? C : D;
            state[C]: next_state = (w == 1'b0) ? E : D;
            state[D]: next_state = (w == 1'b0) ? F : A;
            state[E]: next_state = (w == 1'b0) ? E : D;
            state[F]: next_state = (w == 1'b0) ? C : D;
            default:  next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z=1 in states E or F
    always @(*) begin
        z = (state[E] || state[F]) ? 1'b1 : 1'b0;
    end

endmodule