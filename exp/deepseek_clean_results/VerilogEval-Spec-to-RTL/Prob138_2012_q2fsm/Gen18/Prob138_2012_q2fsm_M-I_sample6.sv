module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoding (6 states need 6 bits)
    parameter [5:0] 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] current_state, next_state;
    wire gated_clk;

    // Clock gating for state E when w=1 (stable state)
    assign gated_clk = (current_state == E && w) ? 1'b0 : clk;

    // Optimized state transition using one-hot properties
    always @(*) begin
        next_state = 6'b0;  // Default to catch undefined states
        case (1'b1)  // Synthesis will optimize this to parallel checks
            current_state[A]: next_state = w ? B : A;
            current_state[B]: next_state = w ? C : D;
            current_state[C]: next_state = w ? E : D;
            current_state[D]: next_state = w ? F : A;
            current_state[E]: next_state = w ? E : D;
            current_state[F]: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // State storage with gated clock and compact reset
    always @(posedge gated_clk) begin
        current_state <= reset ? A : next_state;
    end

    // Output logic - E (010000) or F (100000) have bits 5 or 4 set
    assign z = current_state[5] | current_state[4];

endmodule