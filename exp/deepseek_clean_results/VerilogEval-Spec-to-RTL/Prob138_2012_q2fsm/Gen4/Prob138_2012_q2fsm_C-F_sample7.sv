module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding (6 bits)
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        next_state = A;  // Default assignment
        case (1'b1)  // Synthesis will optimize this
            current_state[A]: next_state = w ? B : A;
            current_state[B]: next_state = w ? C : D;
            current_state[C]: next_state = w ? E : D;
            current_state[D]: next_state = w ? F : A;
            current_state[E]: next_state = w ? E : D;
            current_state[F]: next_state = w ? C : D;
        endcase
    end

    // State storage (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic (z is 1 for states E and F)
    assign z = current_state[E] | current_state[F];

endmodule