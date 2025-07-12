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

    // Next state logic - one-hot encoded FSM
    always @(*) begin
        next_state = 6'b0;
        case (1'b1)
            state[A]: next_state = (w == 1'b0) ? B : A;
            state[B]: next_state = (w == 1'b0) ? C : D;
            state[C]: next_state = (w == 1'b0) ? E : D;
            state[D]: next_state = (w == 1'b0) ? F : A;
            state[E]: next_state = (w == 1'b0) ? E : D;
            state[F]: next_state = (w == 1'b0) ? C : D;
            default: next_state = A;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Registered output logic: z = 1 in states E or F only
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= (state == E || state == F);
    end

endmodule