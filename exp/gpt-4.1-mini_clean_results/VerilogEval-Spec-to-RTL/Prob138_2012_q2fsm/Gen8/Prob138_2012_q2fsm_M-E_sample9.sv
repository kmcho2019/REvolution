module TopModule (
    input  clk,
    input  reset,
    input  w,
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

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (1'b1) // Priority encoding style for one-hot
            current_state[A]: next_state = w ? B : A;
            current_state[B]: next_state = w ? C : D;
            current_state[C]: next_state = w ? E : D;
            current_state[D]: next_state = w ? F : A;
            current_state[E]: next_state = w ? E : D;
            current_state[F]: next_state = w ? C : D;
            default:          next_state = A;
        endcase
    end

    // Moore output: z=1 for states E and F, 0 otherwise
    assign z = current_state[E] | current_state[F];

endmodule