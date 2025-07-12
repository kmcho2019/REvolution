module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        next_state = 6'b0; // default no state
        case (1'b1) // One-hot decode
            current_state[A]: next_state = w ? B : A;
            current_state[B]: next_state = w ? C : D;
            current_state[C]: next_state = w ? E : D;
            current_state[D]: next_state = w ? F : A;
            current_state[E]: next_state = w ? E : D;
            current_state[F]: next_state = w ? C : D;
            default: next_state = A; // safety fallback
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic: z = 1 if current state is E or F
    assign z = current_state[E] | current_state[F];

endmodule