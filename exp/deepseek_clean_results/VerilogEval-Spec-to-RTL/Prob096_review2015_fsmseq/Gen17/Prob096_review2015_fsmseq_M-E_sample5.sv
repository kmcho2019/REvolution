module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States representing partial matches of the sequence 1101
    typedef enum logic [2:0] {
        S0 = 3'b000,  // No match
        S1 = 3'b001,  // Matched '1'
        S2 = 3'b010,  // Matched '11'
        S3 = 3'b011,  // Matched '110'
        S4 = 3'b100   // Matched '1101' (complete)
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            S0: next_state = (data == 1'b1) ? S1 : S0;
            S1: next_state = (data == 1'b1) ? S2 : S0;
            S2: next_state = (data == 1'b0) ? S3 : S2;
            S3: next_state = (data == 1'b1) ? S4 : S0;
            S4: next_state = S4;  // Stay in matched state until reset
            default: next_state = S0;
        endcase
    end

    assign start_shifting = (current_state == S4);

endmodule