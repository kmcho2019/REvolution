module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            A: begin
                if (w)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
            end
            C: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
            end
            D: begin
                if (w)
                    next_state = F;
                else
                    next_state = A;
            end
            E: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
            end
            F: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
            end
            default: next_state = A;
        endcase
    end

    // Output logic: z = 1 only in state E, else 0
    assign z = (state == E);

endmodule