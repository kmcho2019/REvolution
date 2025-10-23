module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    typedef enum reg [1:0] {
        IDLE      = 2'b00,
        READ_BITS = 2'b01,
        CHECK_STOP= 2'b10,
        RECOVER   = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt;          // count 0..7 for bits received
    reg [7:0] data_shift;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter register
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == READ_BITS)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Data shift register - shift right, new bit shifted into MSB (LSB first serial)
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == READ_BITS)
            data_shift <= {in, data_shift[7:1]};
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // Output logic and done pulse
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low every cycle

            if (state == CHECK_STOP) begin
                if (in == 1'b1) begin
                    out_byte <= data_shift;
                    done <= 1'b1; // pulse done high for one cycle
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = READ_BITS;
                else
                    next_state = IDLE;
            end

            READ_BITS: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = READ_BITS;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // valid stop bit, ready for next
                else
                    next_state = RECOVER;   // invalid stop bit, wait for idle
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;      // recovered, line idle again
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule