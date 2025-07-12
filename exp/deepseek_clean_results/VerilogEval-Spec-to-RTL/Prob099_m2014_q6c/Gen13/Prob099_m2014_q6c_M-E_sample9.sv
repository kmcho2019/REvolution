module TopModule (
    input [5:0] y,  // Current state (unused in this implementation)
    input w,       // Input signal
    output Y1,     // Output 1
    output Y3      // Output 3
);

    // Internal state representation (3 bits for binary encoding)
    reg [2:0] current_state = 3'b000; // Initialize to state A (000)
    reg [2:0] next_state;

    // State encoding
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    // Update state (would be clocked in real implementation)
    always @(*) current_state = next_state;

    // Output logic
    assign Y1 = (next_state == A); // Y1 is 1 when next state is A
    assign Y3 = (next_state == C); // Y3 is 1 when next state is C

endmodule