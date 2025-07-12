module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states for sequence detection
    typedef enum reg [2:0] {
        S0, // no match
        S1, // matched '1'
        S11, // matched '11'
        S110 // matched '110'
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
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
                if (data)
                    next_state = S11; // 3 consecutive 1's: maintain S11 (can be adjusted)
                else
                    next_state = S110;
            end
            S110: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic for state and output
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Set start_shifting when sequence detected (i.e. on transition from S110 with data=1)
            if (state == S110 && data == 1)
                start_shifting <= 1'b1;
        end
    end

endmodule