module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding with minimal bit toggles
    localparam [2:0] A = 3'b000,  // Reset state
                     D = 3'b001,  // Common transition target
                     C = 3'b011,  // Differs from D by 1 bit
                     B = 3'b010,  // Differs from C by 1 bit
                     E = 3'b110,  // Differs from B by 1 bit (MSB)
                     F = 3'b111;  // Differs from E by 1 bit

    reg [2:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic (z is 1 in states E and F)
    assign z = (current_state == E) | (current_state == F);

endmodule