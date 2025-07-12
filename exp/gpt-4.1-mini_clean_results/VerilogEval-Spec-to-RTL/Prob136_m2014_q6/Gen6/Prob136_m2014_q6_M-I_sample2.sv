module TopModule(
    input clk,
    input reset,
    input w,
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

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (1'b1)  // One-hot encoded state detection
            state[A]: next_state = (w == 0) ? B : A;
            state[B]: next_state = (w == 0) ? C : D;
            state[C]: next_state = (w == 0) ? E : D;
            state[D]: next_state = (w == 0) ? F : A;
            state[E]: next_state = (w == 0) ? E : D;
            state[F]: next_state = (w == 0) ? C : D;
            default:  next_state = A;
        endcase
    end

    always @(*) begin
        // Output z is 1 in states E or F only
        z = state[E] | state[F];
    end

endmodule