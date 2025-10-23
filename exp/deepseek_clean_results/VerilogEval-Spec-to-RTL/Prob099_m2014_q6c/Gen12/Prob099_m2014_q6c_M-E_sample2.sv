module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (C)
);

    // State definitions (one-hot encoding)
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    // Next state logic
    reg [5:0] next_state;
    always @(*) begin
        case (1'b1)
            y[0]: next_state = w ? A : B;       // State A transitions
            y[1]: next_state = w ? D : C;       // State B transitions
            y[2]: next_state = w ? D : E;       // State C transitions
            y[3]: next_state = w ? A : F;       // State D transitions
            y[4]: next_state = w ? D : E;       // State E transitions
            y[5]: next_state = w ? D : C;       // State F transitions
            default: next_state = A;           // Default to state A
        endcase
    end

    // Output assignments
    assign Y1 = next_state[0];  // Next state A
    assign Y3 = next_state[2];  // Next state C

endmodule