module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected,  // New input: high for one cycle when pattern detected
    output wire shift_ena
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state, next_state;
    reg [1:0] counter, next_counter;  // 2 bits to count 4 cycles (3 down to 0)

    // Next state and counter combinational logic
    always @(*) begin
        next_state = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                // On synchronous reset or pattern detection, start ENABLE with counter=3
                if (pattern_detected) begin
                    next_state = ENABLE;
                    next_counter = 2'd3;
                end
                // else remain in IDLE
            end

            ENABLE: begin
                if (counter == 0)
                    next_state = IDLE;
                else
                    next_counter = counter - 1;
            end
        endcase
    end

    // Sequential state and counter update on posedge clk with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            counter <= 2'd3;
        end else begin
            state <= next_state;
            counter <= next_counter;
        end
    end

    // shift_ena asserted during ENABLE state, exactly 4 cycles after reset or pattern detection
    assign shift_ena = (state == ENABLE);

endmodule