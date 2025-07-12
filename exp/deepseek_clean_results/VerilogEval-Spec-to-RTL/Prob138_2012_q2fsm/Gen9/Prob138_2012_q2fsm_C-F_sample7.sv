module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized binary state encoding
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b010,
                     D = 3'b011,
                     E = 3'b100,
                     F = 3'b101;

    reg [2:0] current_state, next_state;

    // State transition logic - optimized for arithmetic transitions where possible
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;          // A->B is +1
            B: next_state = w ? C : D;          // B->C is +1, B->D is +2
            C: next_state = w ? E : D;          // C->D is +1
            D: next_state = w ? F : A;          // D->A is -3 (wrapped)
            E: next_state = w ? E : D;          // E->D is -1
            F: next_state = w ? C : D;          // F->C is -3
            default: next_state = A;
        endcase
    end

    // State storage with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - active when in states E or F (MSB set)
    assign z = current_state[2];

endmodule