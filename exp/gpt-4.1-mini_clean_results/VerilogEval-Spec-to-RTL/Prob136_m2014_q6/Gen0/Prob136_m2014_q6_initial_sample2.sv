module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (w == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end

            C: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end

            D: begin
                if (w == 1'b0)
                    next_state = F;
                else
                    next_state = A;
            end

            E: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end

            F: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end

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

    // Output logic: z is 1 only in states E and F when w is 1 (from the problem's transitions),
    // but from the given transitions z is explicitly shown only for E and F, and only if w=1.
    // So set z=1 when in E or F and w==1, else 0.
    always @(*) begin
        case (current_state)
            E: z = (w == 1'b1) ? 1'b1 : 1'b0;
            F: z = (w == 1'b1) ? 1'b1 : 1'b0;
            default: z = 1'b0;
        endcase
    end

endmodule