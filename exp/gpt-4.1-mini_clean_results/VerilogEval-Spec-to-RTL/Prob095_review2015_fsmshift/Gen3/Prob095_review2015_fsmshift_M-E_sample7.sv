module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected,  // Added pattern detection input as needed for functionality
    output reg  shift_ena
);

    typedef enum logic [0:0] {IDLE=1'b0, ENABLE=1'b1} state_t;
    state_t state, next_state;
    reg [2:0] counter, next_counter;

    // State and counter update
    always @(posedge clk) begin
        if (reset) begin
            state   <= ENABLE;
            counter <= 3'd4;   // Enable for 4 cycles after reset
        end else begin
            state   <= next_state;
            counter <= next_counter;
        end
    end

    // Next state logic and counter decrement logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_counter = counter;
        shift_ena = 1'b0;

        case (state)
            ENABLE: begin
                shift_ena = 1'b1;
                if (counter == 3'd1) begin
                    // Completed 4 cycles
                    next_state = IDLE;
                    next_counter = 3'd0;
                end else begin
                    next_counter = counter - 1;
                end
            end

            IDLE: begin
                shift_ena = 1'b0;
                // Detect pattern and enable for 4 cycles
                if (pattern_detected) begin
                    next_state = ENABLE;
                    next_counter = 3'd4;
                end
            end
        endcase
    end

endmodule