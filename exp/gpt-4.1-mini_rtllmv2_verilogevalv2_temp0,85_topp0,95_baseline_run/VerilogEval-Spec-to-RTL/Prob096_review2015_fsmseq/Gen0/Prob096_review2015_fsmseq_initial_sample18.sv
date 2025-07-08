module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states representing how much of the sequence "1101" has been matched
    typedef enum reg [2:0] {
        S0 = 3'd0, // initial state, no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '11'
        S3 = 3'd3, // matched '110'
        S4 = 3'd4  // matched '1101' - final detection state
    } state_t;

    state_t state, next_state;

    // Combinational next state logic
    always @(*) begin
        case(state)
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
                    next_state = S2; // '111' partial matches '11' again
                else
                    next_state = S3;
            end
            S3: begin
                if (data)
                    next_state = S4; // sequence detected
                else
                    next_state = S0;
            end
            S4: begin
                // Once sequence detected, stay in S4 until reset
                next_state = S4;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential state update and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // start_shifting is set to 1 forever once sequence detected
            if (state == S4 || start_shifting)
                start_shifting <= 1'b1;
        end
    end

endmodule