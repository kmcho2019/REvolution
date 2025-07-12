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

    // Bit counter with enable in RX_DATA only
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 4'd0;
        else if (state == RX_DATA)
            bit_cnt <= bit_cnt + 4'd1;
        else
            bit_cnt <= 4'd0;
    end

    // Data shift register with enable in RX_DATA only
    // Shift left and insert new bit at LSB to match LSB-first serial input
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == RX_DATA)
            data_shift <= {in, data_shift[7:1]};
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