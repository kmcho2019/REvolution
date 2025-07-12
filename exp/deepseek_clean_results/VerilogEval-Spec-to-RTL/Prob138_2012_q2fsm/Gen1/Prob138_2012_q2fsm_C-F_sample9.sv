module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding with Gray-like ordering to minimize transitions
    // States ordered to have single-bit changes between frequent transitions
    localparam [2:0] A = 3'b000,  // Reset state
                     D = 3'b001,  // Common transition target
                     B = 3'b011,  // From A
                     C = 3'b010,  // From B/D/F
                     F = 3'b110,  // From D
                     E = 3'b100;  // From C

    reg [2:0] current_state, next_state;

    // State storage (sequential logic)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // State transitions (combinational logic)
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            // No default needed as all cases covered
        endcase
    end

    // Output logic (z is 1 in states E and F)
    assign z = (current_state == E) || (current_state == F);

endmodule