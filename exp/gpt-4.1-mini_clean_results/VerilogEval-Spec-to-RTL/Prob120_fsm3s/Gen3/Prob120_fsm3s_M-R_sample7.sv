module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);
    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;

    // Combinational logic for next state and output
    always @(*) begin
        case(state)
            A: begin
                out = 1'b0;
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                out = 1'b0;
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                out = 1'b0;
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            D: begin
                out = 1'b1;
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            default: begin
                out = 1'b0;
                next_state = A;
            end
        endcase
    end

    // Sequential logic for state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule