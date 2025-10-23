module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;

    // Next state and output logic
    always @(*) begin
        case (state)
            A: begin
                if (in)
                    next_state = B;
                else
                    next_state = A;
                out = 1'b0;
            end
            B: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
                out = 1'b0;
            end
            C: begin
                if (in)
                    next_state = D;
                else
                    next_state = A;
                out = 1'b0;
            end
            D: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
                out = 1'b1;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule