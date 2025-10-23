module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding with documentation
    localparam [2:0]
        A = 3'b000,  // State A (z=0)
        B = 3'b001,  // State B (z=0)
        C = 3'b011,  // State C (z=0)
        D = 3'b010,  // State D (z=0)
        E = 3'b110,  // State E (z=1)
        F = 3'b100;  // State F (z=1)

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A; // Safe default
        endcase
    end

    // Sequential state transition
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is MSB of state (E and F states have z=1)
    assign z = state[2];

endmodule