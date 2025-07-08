module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding
    typedef enum reg {OFF=1'b0, ON=1'b1} state_t;
    state_t current_state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        case (current_state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule