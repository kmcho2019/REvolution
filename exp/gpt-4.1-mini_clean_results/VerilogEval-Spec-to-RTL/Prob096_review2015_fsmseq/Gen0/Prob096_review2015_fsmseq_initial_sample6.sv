module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    typedef enum logic [2:0] {
        S0 = 3'b000, // no match
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched '11'
        S3 = 3'b011, // matched '110'
        S4 = 3'b100  // matched '1101' (final state)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (data == 1'b1) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                if (data == 1'b1) next_state = S2;
                else next_state = S0;
            end
            S2: begin
                if (data == 1'b0) next_state = S3;
                else next_state = S2; // '11' followed by 1 is still '11'
            end
            S3: begin
                if (data == 1'b1) next_state = S4;
                else next_state = S0;
            end
            S4: begin
                // Stay in S4 once sequence found
                next_state = S4;
            end
            default: next_state = S0;
        endcase
    end

    // State register and output logic, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S4)
                start_shifting <= 1'b1;
            // Once start_shifting set, it remains set; no else needed because S4 is sticky
        end
    end

endmodule