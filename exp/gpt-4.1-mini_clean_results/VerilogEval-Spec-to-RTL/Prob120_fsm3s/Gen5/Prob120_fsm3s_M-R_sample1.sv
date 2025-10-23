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

    // Combinational logic for next state and output
    always @(*) begin
        next_state = A; // default
        out = 1'b0;     // default output

        case (state)
            A: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
            end
            D: begin
                out = 1'b1;
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: begin
                out = 1'b0;
                next_state = A;
            end
        endcase
    end

    // Sequential state register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule