module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    typedef enum reg {OFF = 1'b0, ON = 1'b1} state_t;
    reg state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            case (next_state)
                OFF: out <= 1'b0;
                ON:  out <= 1'b1;
            endcase
        end
    end

    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

endmodule