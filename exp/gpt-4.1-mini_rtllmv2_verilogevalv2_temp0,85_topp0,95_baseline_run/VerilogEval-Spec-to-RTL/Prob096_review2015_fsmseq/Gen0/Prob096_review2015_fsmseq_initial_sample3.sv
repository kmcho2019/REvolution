module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding for sequence detection of "1101"
    typedef enum reg [2:0] {
        S0 = 3'd0, // initial state, no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '11'
        S3 = 3'd3, // matched '110'
        S4 = 3'd4  // matched '1101' (final)
    } state_t;

    state_t current_state, next_state;

    // Sequential logic: state and output update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            // Once start_shifting is set, keep it set forever until reset
            if (start_shifting)
                start_shifting <= 1'b1;
            else if (next_state == S4)
                start_shifting <= 1'b1;
            else
                start_shifting <= 1'b0;
        end
    end

    // Combinational logic: next state logic
    always @(*) begin
        case(current_state)
            S0: begin
                if (data == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data == 1'b1)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (data == 1'b0)
                    next_state = S3;
                else
                    next_state = S2; // '11' repeated, stay in S2
            end
            S3: begin
                if (data == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                // stay in S4 indefinitely once matched
                next_state = S4;
            end
            default: next_state = S0;
        endcase
    end

endmodule