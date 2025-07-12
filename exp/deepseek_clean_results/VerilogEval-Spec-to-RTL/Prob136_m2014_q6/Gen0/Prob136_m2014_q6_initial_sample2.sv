module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Define states using parameters (3 bits for 6 states)
    parameter [2:0] A = 3'b000,
                   B = 3'b001,
                   C = 3'b010,
                   D = 3'b011,
                   E = 3'b100,
                   F = 3'b101;

    reg [2:0] current_state, next_state;

    // State register (sequential logic)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic (combinational)
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

    // Output logic (z=1 only in states E and F)
    assign z = (current_state == E) || (current_state == F);

endmodule