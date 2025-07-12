module TopModule (
    input [5:0] y,  // Original one-hot input (kept for interface compatibility)
    input w,
    output Y1,      // Next state B
    output Y2,      // Next state C
    output Y3,      // Next state D
    output Y4       // Next state E
);

    // State encoding (3 bits)
    parameter [2:0] A = 3'b000;
    parameter [2:0] B = 3'b001;
    parameter [2:0] C = 3'b010;
    parameter [2:0] D = 3'b011;
    parameter [2:0] E = 3'b100;
    parameter [2:0] F = 3'b101;

    // Current state (decoded from one-hot input)
    wire [2:0] current_state;
    assign current_state = y[0] ? A :
                          y[1] ? B :
                          y[2] ? C :
                          y[3] ? D :
                          y[4] ? E :
                          y[5] ? F : A;  // Default to A

    // Next state logic
    reg [2:0] next_state;
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

    // Output assignments
    assign Y1 = (next_state == B);
    assign Y2 = (next_state == C);
    assign Y3 = (next_state == D);
    assign Y4 = (next_state == E);

endmodule