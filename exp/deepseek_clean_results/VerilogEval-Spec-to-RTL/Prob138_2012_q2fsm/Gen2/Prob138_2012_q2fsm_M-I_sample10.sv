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

    reg [5:0] current_state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic - optimized for one-hot
    always @(*) begin
        next_state = 6'b0;  // Default to invalid state (will be caught by reset)
        case (1'b1)  // Synthesis will recognize this as priority encoder
            current_state[A]: next_state = w ? B : A;
            current_state[B]: next_state = w ? C : D;
            current_state[C]: next_state = w ? E : D;
            current_state[D]: next_state = w ? F : A;
            current_state[E]: next_state = w ? E : D;
            current_state[F]: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // Output logic - simply OR of E and F bits (bit 4 and 5)
    assign z = current_state[E] | current_state[F];

endmodule