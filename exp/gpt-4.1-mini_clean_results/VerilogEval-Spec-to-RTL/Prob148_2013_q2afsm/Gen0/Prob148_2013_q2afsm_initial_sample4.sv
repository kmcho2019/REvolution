module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3
    } state_t;

    state_t state, next_state;

    // State flip-flops with synchronous active low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            A: begin
                // Priority: r[0] > r[1] > r[2]
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            B: begin
                // Stay in B if r[0] asserted, else back to A
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end
            C: begin
                // Stay in C if r[1] asserted, else back to A
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end
            D: begin
                // From problem statement, D state transitions are not explicitly given,
                // but by analogy it should stay in D as long as r[2] asserted,
                // else return to A
                if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            default: next_state = A;
        endcase
    end

    // Output logic: one-hot grant signals for the granted device
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule