module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    reg [5:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[A]: next_state = w ? B : A;
            state[B]: next_state = w ? C : D;
            state[C]: next_state = w ? E : D;
            state[D]: next_state = w ? F : A;
            state[E]: next_state = w ? E : D;
            state[F]: next_state = w ? C : D;
            default:  next_state = A;
        endcase
    end

    // State registers (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic (z is high in states E or F)
    assign z = state[E] | state[F];

endmodule