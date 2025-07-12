module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    parameter [5:0] A = 6'b000001;
    parameter [5:0] B = 6'b000010;
    parameter [5:0] C = 6'b000100;
    parameter [5:0] D = 6'b001000;
    parameter [5:0] E = 6'b010000;
    parameter [5:0] F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Next state logic
    always @(*) begin
        case (1'b1)  // Synthesis will optimize this case statement
            current_state[A]: next_state = w ? A : B;
            current_state[B]: next_state = w ? D : C;
            current_state[C]: next_state = w ? D : E;
            current_state[D]: next_state = w ? A : F;
            current_state[E]: next_state = w ? D : E;
            current_state[F]: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic (E or F states)
    assign z = current_state[E] | current_state[F];

endmodule