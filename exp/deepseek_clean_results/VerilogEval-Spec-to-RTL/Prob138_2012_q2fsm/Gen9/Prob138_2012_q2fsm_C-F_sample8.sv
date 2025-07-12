module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding:
    // - Gray-like for A-D transitions (minimal bit changes)
    // - MSB=1 for z=1 states (E,F)
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     D = 3'b011,  // Central state with minimal encoding
                     C = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state, next_state;

    // State transition logic - optimized case structure
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // Full case coverage
        endcase
    end

    // State register with efficient reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Optimal output logic - single bit check
    assign z = current_state[2];

endmodule