module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum reg [2:0] {
        S0, // initial state, no bits matched
        S1, // matched '1'
        S2, // matched '11'
        S3, // matched '110'
        S4  // matched '1101' (sequence found)
    } state_t;

    state_t current_state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            // Set start_shifting to 1 permanently after sequence found
            if (current_state == S4)
                start_shifting <= 1'b1;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
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
                    next_state = S2; // stays if next bit is 1 (sequence is 11)
            end
            S3: begin
                if (data == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                // Once sequence found, stay in S4 indefinitely
                next_state = S4;
            end
            default: next_state = S0;
        endcase
    end

endmodule