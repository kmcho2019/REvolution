module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    // Define states using enumerated type
    typedef enum logic [1:0] {
        RESET_EN = 2'b00,
        IDLE     = 2'b01
        // Future states like PATTERN_DETECT can be added here
    } state_t;

    state_t state, next_state;
    logic [2:0] count; // 3-bit counter to count up to 4

    // State transition and counter logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET_EN;
            count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == RESET_EN)
                count <= count + 3'd1;
            else
                count <= 3'd0;
        end
    end

    // Next state logic
    always_comb begin
        case (state)
            RESET_EN: next_state = (count == 3'd3) ? IDLE : RESET_EN;
            IDLE:     next_state = IDLE; // Remain idle until reset
            default:  next_state = IDLE;
        endcase
    end

    // Output logic: shift_ena is high for exactly 4 cycles in RESET_EN state (count 0 to 3)
    assign shift_ena = (state == RESET_EN) ? 1'b1 : 1'b0;

endmodule