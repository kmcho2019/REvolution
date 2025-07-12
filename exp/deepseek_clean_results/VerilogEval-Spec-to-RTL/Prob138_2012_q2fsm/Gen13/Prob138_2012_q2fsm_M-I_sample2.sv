module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Pure Gray code encoding for minimal transitions
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111,
                     UNUSED1 = 3'b100,
                     UNUSED2 = 3'b101;

    reg [2:0] current_state, next_state;

    // State transition logic with full case coverage
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            UNUSED1,
            UNUSED2: next_state = A;  // Handle unused states
            default: next_state = A;  // Robust default case
        endcase
    end

    // State storage with synchronous reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Output logic - now checks for states E or F (both have MSB set)
    assign z = current_state[2];

endmodule