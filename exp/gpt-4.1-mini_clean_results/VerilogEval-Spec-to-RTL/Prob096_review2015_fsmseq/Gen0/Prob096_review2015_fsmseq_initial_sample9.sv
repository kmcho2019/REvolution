module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states for the FSM
    typedef enum reg [2:0] {
        S0 = 3'b000, // initial state, no match yet
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched '11'
        S3 = 3'b011, // matched '110'
        S4 = 3'b100  // matched '1101' (final state)
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
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
                    next_state = S2; // stay in S2 because input = 1 keeps the two ones matched
            end

            S3: begin
                if (data == 1'b1)
                    next_state = S4; // sequence matched
                else
                    next_state = S0;
            end

            S4: begin
                next_state = S4; // remain in final state forever
            end

            default: next_state = S0;
        endcase
    end

    // Sequential logic and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == S4)
                start_shifting <= 1'b1;
            // once start_shifting is 1, remain 1 until reset, so no else clause to clear it
        end
    end

endmodule