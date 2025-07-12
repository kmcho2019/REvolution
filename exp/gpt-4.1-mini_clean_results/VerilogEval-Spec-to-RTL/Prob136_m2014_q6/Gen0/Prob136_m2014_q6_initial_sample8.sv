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

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
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
                // w=1 for states E,F is indicated on output in the problem, but the transitions mention (1), presumably for output.
                // The problem states "E (1) --0--> E" etc. This implies input w=0 leads to next state E, input w=1 leads to D.
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
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case(state)
            E, F: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule