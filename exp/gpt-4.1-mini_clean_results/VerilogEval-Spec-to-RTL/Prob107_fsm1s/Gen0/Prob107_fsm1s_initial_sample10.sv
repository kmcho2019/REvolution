module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    typedef enum logic {B=1'b0, A=1'b1} state_t;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            B: begin
                out = 1'b1;
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: begin
                out = 1'b1;
                next_state = B;
            end
        endcase
    end

endmodule