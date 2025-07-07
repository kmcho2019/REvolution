module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'b000, // no match yet
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched '11'
        S3 = 3'b011, // matched '110'
        S4 = 3'b100  // matched '1101' (final)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
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
                    next_state = S2; // stay in S2 if input is 1 (sequence 11...)
            end
            S3: begin
                if (data == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                // Once sequence found, stay in S4 forever until reset
                next_state = S4;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == S4)
                start_shifting <= 1'b1;
        end
    end

endmodule