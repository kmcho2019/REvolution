module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding: 3 bits needed for 6 states
    // Assign states so that bit 1 indicates output z:
    // A=3'b000, B=3'b001, C=3'b100, D=3'b101, E=3'b011, F=3'b010
    // States E(011) and F(010) have bit 1 = 1, so z = state[1]
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b100,
                     D = 3'b101,
                     E = 3'b011,
                     F = 3'b010;

    reg [2:0] state, next_state;

    // Next state logic using if-else for potential simpler logic
    always @(*) begin
        case(state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z is bit 1 of state
    assign z = state[1];

endmodule