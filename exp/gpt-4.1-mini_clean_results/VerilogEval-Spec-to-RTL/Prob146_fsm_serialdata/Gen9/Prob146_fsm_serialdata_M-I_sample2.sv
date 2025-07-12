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

    reg [2:0] bit_cnt;          // counts 0..7 for bits received
    reg [7:0] data_shift;

    // Enable signals to reduce toggling
    wire bit_cnt_en = (state == READ_BITS);
    wire data_shift_en = (state == READ_BITS);

    // State register
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
        else if (bit_cnt_en)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Data shift register - shift right, new bit into MSB (LSB first serial), with enable
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (data_shift_en)
            data_shift <= {in, data_shift[7:1]};
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // done pulse register - asserted one cycle on valid stop bit
    reg done_reg;
    always @(posedge clk) begin
        if (reset)
            done_reg <= 1'b0;
        else if (state == CHECK_STOP && in == 1'b1)
            done_reg <= 1'b1;
        else
            done_reg <= 1'b0;
    end

    // Output data register updated only when done is asserted
    always @(posedge clk) begin
        if (reset)
            out_byte <= 8'd0;
        else if (done_reg)
            out_byte <= data_shift;
    end

    // Output done is driven by done_reg
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= done_reg;
    end

    // Next state logic (combinational)
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
                    next_state = IDLE;      // valid stop bit, ready for next byte
                else
                    next_state = RECOVER;   // invalid stop bit, wait for idle line
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