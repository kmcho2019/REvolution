module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // One-hot state encoding
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: state flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic using one-hot encoding
    always @(*) begin
        // Default next_state to all zeros (no state)
        next_state = 6'b000000;

        case (1'b1)
            state[A]: next_state = w ? B : A;
            state[B]: next_state = w ? C : D;
            state[C]: next_state = w ? E : D;
            state[D]: next_state = w ? F : A;
            state[E]: next_state = w ? E : D;
            state[F]: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // Output logic: z is high when in states E or F
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule