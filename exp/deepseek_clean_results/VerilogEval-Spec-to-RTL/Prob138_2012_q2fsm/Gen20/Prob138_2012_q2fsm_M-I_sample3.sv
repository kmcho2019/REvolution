module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding with z=state[5]|state[4]
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,  // z=1
                     F = 6'b100000;  // z=1

    reg [5:0] current_state, next_state;

    // Pure case statement for state transitions
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;    // Handle power-up or errors
        endcase
    end

    // State storage with synchronous reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Output logic - direct bit check (E or F states)
    assign z = current_state[5] | current_state[4];

endmodule