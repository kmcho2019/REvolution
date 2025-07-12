module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam [1:0]
        IDLE       = 2'b00,
        RX_DATA    = 2'b01,
        CHECK_STOP = 2'b10,
        WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] data_shift;
    reg [3:0] bit_cnt;  // 4 bits to count up to 8
    reg done_next;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 4'd0;
        else if (state == RX_DATA)
            bit_cnt <= bit_cnt + 4'd1;
        else
            bit_cnt <= 4'd0;
    end

    // Data shift register: shift right with new bit entering at MSB or LSB?
    // Protocol sends LSB first, so shift right and insert bit at MSB does not fit.
    // Instead, shift left and insert LSB at data_shift[0]
    // So: data_shift <= {in, data_shift[7:1]} actually puts the latest bit at MSB (incorrect)
    // Instead, shift right with incoming bit at MSB means MSB is newest bit, but protocol wants LSB first.
    // So shift left and insert in LSB: data_shift <= {in, data_shift[7:1]} would shift right.
    // Correct is shift right and put new bit at MSB (incorrect as LSB first).
    // Better to shift right and put new bit at MSB, then reverse bits after reception, or
    // shift left and put bit in LSB: data_shift <= {data_shift[6:0], in}
    // That puts latest bit at LSB, which is correct for LSB first serial input.

    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == RX_DATA)
            data_shift <= {in, data_shift[7:1]}; // shift right, LSB first: newest bit is LSB
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // done signal pulse generation
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= done_next;
    end

    // Output data byte latch when stop bit valid
    always @(posedge clk) begin
        if (reset)
            out_byte <= 8'd0;
        else if (done_next)
            out_byte <= data_shift;
    end

    // Next state and done logic
    always @(*) begin
        done_next = 1'b0;
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RX_DATA;
                else
                    next_state = IDLE;
            end

            RX_DATA: begin
                if (bit_cnt == 4'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RX_DATA;
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin // valid stop bit
                    done_next = 1'b1;
                    next_state = IDLE;
                end else
                    next_state = WAIT_STOP; // invalid stop bit: wait until line idle
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule