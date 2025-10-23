module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    typedef enum logic [2:0] {
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '11'
        S3 = 3'd3  // matched '110'
    } state_t;

    state_t state, next_state;
    logic start_shifting_reg;

    // Next state logic combinational function
    function state_t f_next_state(state_t curr_state, logic bit);
        case (curr_state)
            S0: f_next_state = bit ? S1 : S0;
            S1: f_next_state = bit ? S2 : S0;
            S2: f_next_state = bit ? S2 : S3;
            S3: f_next_state = bit ? S1 : S0;
            default: f_next_state = S0;
        endcase
    endfunction

    // Sequential logic: state update and start_shifting latch
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting_reg <= 1'b0;
        end else begin
            state <= f_next_state(state, data);
            // Latch start_shifting once sequence 1101 detected (at S3 followed by input=1, next state = S1)
            if (~start_shifting_reg && (state == S3) && data)
                start_shifting_reg <= 1'b1;
        end
    end

    assign start_shifting = start_shifting_reg;

endmodule