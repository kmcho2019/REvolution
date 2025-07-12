module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Parallel computation of all possible next states
    wire [5:0] next_A = w ? B : A;
    wire [5:0] next_B = w ? C : D;
    wire [5:0] next_C = w ? E : D;
    wire [5:0] next_D = w ? F : A;
    wire [5:0] next_E = w ? E : D;
    wire [5:0] next_F = w ? C : D;

    // Decision tree for state transition
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            current_state[A]: next_state = next_A;
            current_state[B]: next_state = next_B;
            current_state[C]: next_state = next_C;
            current_state[D]: next_state = next_D;
            current_state[E]: next_state = next_E;
            current_state[F]: next_state = next_F;
            default: next_state = A; // Handle error cases
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) current_state <= A;
        else current_state <= next_state;
    end

    // Output is 1 for states E and F (bits 4 and 5)
    assign z = current_state[4] | current_state[5];

endmodule