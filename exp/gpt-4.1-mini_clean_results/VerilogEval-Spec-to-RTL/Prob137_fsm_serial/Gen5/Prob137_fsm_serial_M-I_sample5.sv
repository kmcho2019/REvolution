module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Binary encoded FSM states
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;       // 3-bit counter for 0-7 bits
    reg [7:0] shift_reg;       // 8-bit shift register for data bits
    reg shift_en;
    reg bitcount_en;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
            shift_en <= 1'b0;
            bitcount_en <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low

            // Control enables based on state
            shift_en <= (next_state == RECEIVE);
            bitcount_en <= (next_state == RECEIVE);

            // Shift register update
            if (shift_en) begin
                // Shift in new bit into LSB (LSB first), shift register shifts right
                shift_reg <= {in, shift_reg[7:1]};
            end else if (next_state == IDLE || next_state == WAIT_STOP) begin
                shift_reg <= 8'd0;
            end

            // Bit counter update
            if (bitcount_en) begin
                bit_count <= bit_count + 1'b1;
            end else if (next_state == IDLE || next_state == WAIT_STOP) begin
                bit_count <= 3'd0;
            end

            // Assert done when a valid stop bit is detected in CHECK_STOP state
            if (state == CHECK_STOP && in == 1'b1)
                done <= 1'b1;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;   // Detect start bit
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;  // After 8 data bits received
                else
                    next_state = RECEIVE;
            end
            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;        // Correct stop bit, go idle
                else
                    next_state = WAIT_STOP;   // Wait for stop bit
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;        // Stop bit detected, go idle
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule