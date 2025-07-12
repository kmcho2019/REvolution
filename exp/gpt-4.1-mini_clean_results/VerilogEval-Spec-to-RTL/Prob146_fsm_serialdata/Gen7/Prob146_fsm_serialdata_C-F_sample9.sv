module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // FSM state encoding (2-bit binary)
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;       // Counts data bits received (0 to 7)
    reg [7:0] data_shift;    // Shift register for data bits (LSB first)

    wire receive_enable = (state == RECEIVE);

    // Sequential FSM state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter: reset on start bit detection, increment only in RECEIVE state
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == IDLE && in == 1'b0)
            bit_cnt <= 3'd0;
        else if (receive_enable)
            bit_cnt <= bit_cnt + 3'd1;
    end

    // Shift register: clear on start bit detection; shift in LSB first on each RECEIVE cycle
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {in, data_shift[7:1]};
    end

    // Output and done signal logic: done pulse asserted only when valid stop bit detected
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default done low each cycle
            // On valid stop bit in CHECK_STOP state
            if (state == CHECK_STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

    // Combinational next-state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;  // Detected start bit (0)
                else
                    next_state = IDLE;     // Remain idle if line is high (idle)
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;  // After 8 data bits, check stop bit next
                else
                    next_state = RECEIVE;     // Continue receiving data bits
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;        // Valid stop bit, return to idle ready for next byte
                else
                    next_state = WAIT_STOP;   // Invalid stop bit, wait for stop bit (line high)
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;        // Stop bit detected, resume idle
                else
                    next_state = WAIT_STOP;   // Keep waiting for stop bit
            end

            default:
                next_state = IDLE;            // Safe fallback
        endcase
    end

endmodule