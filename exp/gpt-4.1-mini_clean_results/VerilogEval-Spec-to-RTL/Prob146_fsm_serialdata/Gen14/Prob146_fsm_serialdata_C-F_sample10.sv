module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary, 2-bit)
    typedef enum reg [1:0] {
        IDLE    = 2'b00,
        READ    = 2'b01,
        CHECK   = 2'b10,
        RECOVER = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_cnt;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = READ;
                else
                    next_state = IDLE;
            end

            READ: begin
                // Read 8 bits serially
                if (bit_cnt == 3'd7)
                    next_state = CHECK;
                else
                    next_state = READ;
            end

            CHECK: begin
                // Verify stop bit
                if (in == 1'b1)
                    next_state = IDLE;    // Valid stop bit, next byte
                else
                    next_state = RECOVER; // Invalid stop bit, wait idle
            end

            RECOVER: begin
                // Wait for line idle (stop bit = 1) before restart
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter and data_shift register update (only in READ state)
    always @(posedge clk) begin
        if (reset) begin
            bit_cnt <= 3'd0;
            data_shift <= 8'd0;
        end else if (state == READ) begin
            bit_cnt <= bit_cnt + 3'd1;
            // Shift right, new serial bit at MSB (LSB-first protocol)
            data_shift <= {in, data_shift[7:1]};
        end else if (state == IDLE) begin
            // Reset bit count and shift register for next byte on idle
            bit_cnt <= 3'd0;
            data_shift <= 8'd0;
        end
        // In CHECK and RECOVER, hold bit_cnt and data_shift
    end

    // Output logic and done pulse
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no pulse

            // On CHECK state with valid stop bit, latch data and pulse done
            if (state == CHECK && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule