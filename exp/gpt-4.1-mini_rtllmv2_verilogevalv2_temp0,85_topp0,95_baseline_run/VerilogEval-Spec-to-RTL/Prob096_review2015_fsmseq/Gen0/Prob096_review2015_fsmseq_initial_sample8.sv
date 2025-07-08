module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding
    typedef enum reg [2:0] {
        S0, // no bits matched
        S1, // matched 1
        S11, // matched 11
        S110, // matched 110
        S1101_found // sequence found
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data)
                    next_state = S11;
                else
                    next_state = S0;
            end
            S11: begin
                if (~data)
                    next_state = S110;
                else
                    next_state = S11; // stay on 11 if another 1 arrives
            end
            S110: begin
                if (data)
                    next_state = S1101_found;
                else
                    next_state = S0;
            end
            S1101_found: begin
                next_state = S1101_found;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
        end else begin
            state <= next_state;
            if (next_state == S1101_found)
                start_shifting <= 1;
        end
    end

endmodule