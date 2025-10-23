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

    // Combinational next-state and output logic
    always @(*) begin
        case (state)
            A: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
                out = 1'b0;
            end
            B: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
                out = 1'b0;
            end
            C: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
                out = 1'b0;
            end
            D: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
                out = 1'b1;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule