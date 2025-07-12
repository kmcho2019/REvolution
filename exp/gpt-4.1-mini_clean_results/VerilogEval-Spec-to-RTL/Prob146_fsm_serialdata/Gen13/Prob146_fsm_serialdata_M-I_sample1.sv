module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding using localparam for simpler synthesis
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    wire shift_enable = (state == RECEIVE);
    wire count_enable = (state == RECEIVE);

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:
                // Wait for start bit (0)
                next_state = (in == 1'b0) ? RECEIVE : IDLE;

            RECEIVE:
                // After receiving 8 bits, go to STOP state
                next_state = (bit_count == 3'd7) ? STOP : RECEIVE;

            STOP:
                // If stop bit (1) received, go to IDLE, else wait for valid stop bit
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            WAIT_STOP:
                // Wait here until stop bit (1) is seen
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            default:
                next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter update: count bits only during RECEIVE state
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && next_state == RECEIVE)
            bit_count <= 3'd0;  // reset count on start bit detection
        else if (count_enable)
            bit_count <= bit_count + 1;
    end

    // Data shift register update (shift LSB first)
    // Shift left by one bit, new LSB is input bit
    // Only shift during RECEIVE state to reduce toggling otherwise
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && next_state == RECEIVE)
            data_shift <= 8'd0;  // clear on start bit detection
        else if (shift_enable)
            data_shift <= {in, data_shift[7:1]};
        // else hold current value (no toggling)
    end

    // Output logic: latch data and assert done when stop bit correct (one cycle pulse)
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule