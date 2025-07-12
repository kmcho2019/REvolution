module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output wire start_shifting
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'd0, // no bits matched yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched "11"
        S3 = 3'd3, // matched "110"
        S4 = 3'd4  // matched "1101" (sticky final)
    } state_t;

    state_t state, next_state;
    reg detected;

    // Next state logic as a combinational function
    function state_t get_next_state(state_t curr, logic in_bit);
        case (curr)
            S0: get_next_state = in_bit ? S1 : S0;
            S1: get_next_state = in_bit ? S2 : S0;
            S2: get_next_state = in_bit ? S2 : S3;
            S3: get_next_state = in_bit ? S4 : S0;
            S4: get_next_state = S4;
            default: get_next_state = S0;
        endcase
    endfunction

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            detected <= 1'b0;
        end else begin
            state <= get_next_state(state, data);
            // Set detected sticky flag when entering S4
            if (state != S4 && get_next_state(state, data) == S4)
                detected <= 1'b1;
        end
    end

    // Output asserted when detected sticky flag is set
    assign start_shifting = detected;

endmodule