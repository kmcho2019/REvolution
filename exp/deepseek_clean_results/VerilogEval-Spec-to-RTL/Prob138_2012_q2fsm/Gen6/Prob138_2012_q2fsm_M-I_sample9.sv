module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding (6 states)
    parameter [5:0] A = 6'b000001;
    parameter [5:0] B = 6'b000010;
    parameter [5:0] C = 6'b000100;
    parameter [5:0] D = 6'b001000;
    parameter [5:0] E = 6'b010000;
    parameter [5:0] F = 6'b100000;

    reg [5:0] state;

    // State transition logic using case statement
    reg [5:0] next_state;
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[A]: next_state = w ? B : A;
            state[B]: next_state = w ? C : D;
            state[C]: next_state = w ? E : D;
            state[D]: next_state = w ? F : A;
            state[E]: next_state = w ? E : D;
            state[F]: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z is high for states E and F (bits 4 and 5)
    assign z = state[4] | state[5];

endmodule