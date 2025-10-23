module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot encoded states: 5 bits, only one bit high at a time
    localparam IDLE           = 5'b00001,
               START_BIT_CHECK= 5'b00010,
               DATA_RECV      = 5'b00100,
               STOP_BIT_CHECK = 5'b01000,
               WAIT_FOR_IDLE  = 5'b10000;

    reg [4:0] state, next_state;

    reg [2:0] bit_cnt;       // count of data bits received (0-7)
    reg [7:0] data_reg;      // data shift register

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter register with enable
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == DATA_RECV)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Data register shifts in bits LSB first during DATA_RECV
    always @(posedge clk) begin
        if (reset)
            data_reg <= 8'd0;
        else if (state == DATA_RECV) begin
            // Shift right, load new bit into MSB position so LSB first serial data ends up correctly.
            // Actually, since serial is LSB first, we shift data left and put new bit into bit 0:
            // So, shift data_reg left by 1, and put incoming bit at bit 0.
            data_reg <= {in, data_reg[7:1]};
        end else if (state == START_BIT_CHECK) begin
            data_reg <= 8'd0; // clear data before reading
        end
    end

    // Output and done pulse logic
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default low

            if (state == STOP_BIT_CHECK && in == 1'b1) begin
                // Valid stop bit, latch output and pulse done
                out_byte <= data_reg;
                done <= 1'b1;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                // Wait for start bit: input line must go low (0)
                if (in == 1'b0)
                    next_state = START_BIT_CHECK;
                else
                    next_state = IDLE;
            end

            START_BIT_CHECK: begin
                // Confirm that start bit still low on this clock (to filter glitches)
                if (in == 1'b0)
                    next_state = DATA_RECV;
                else
                    next_state = IDLE;  // false start bit, go back to idle
            end

            DATA_RECV: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP_BIT_CHECK; // after receiving 8 bits
                else
                    next_state = DATA_RECV;
            end

            STOP_BIT_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;       // valid stop bit, ready for next
                else
                    next_state = WAIT_FOR_IDLE; // wait for line idle before next byte
            end

            WAIT_FOR_IDLE: begin
                if (in == 1'b1)
                    next_state = IDLE;       // recovered to idle line
                else
                    next_state = WAIT_FOR_IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule