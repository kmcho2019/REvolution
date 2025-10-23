module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // Binary-encoded states
    typedef enum reg [2:0] {
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched "11"
        S3 = 3'd3, // matched "110"
        S4 = 3'd4, // detected "1101"
        S5 = 3'd5  // latched detected state
    } state_t;

    state_t state, next_state;
    reg detected_now;

    // Next state and detected_now combinational logic (Mealy style)
    always @(*) begin
        next_state = state;
        detected_now = 1'b0;

        case (state)
            S0: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (data)
                    next_state = S2;
                else
                    next_state = S3;
            end
            S3: begin
                if (data) begin
                    next_state = S4;
                    detected_now = 1'b1;
                end else begin
                    next_state = S0;
                end
            end
            S4: begin
                // After detection pulse, latch the detected state
                next_state = S5;
            end
            S5: begin
                // Remain latched forever until reset
                next_state = S5;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and output latching
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Latch start_shifting when detected or keep latched in S5
            if (detected_now || state == S5)
                start_shifting <= 1'b1;
        end
    end

endmodule