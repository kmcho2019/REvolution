module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    typedef enum logic [1:0] {A, B, C, D} state_t;
    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            A: if      (r[0]) next_state = B;
               else if (r[1]) next_state = C;
               else if (r[2]) next_state = D;
               else           next_state = A;
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 : 3'b000;

endmodule