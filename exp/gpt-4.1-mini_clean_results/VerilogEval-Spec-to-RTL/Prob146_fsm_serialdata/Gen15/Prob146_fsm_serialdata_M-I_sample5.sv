module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam IDLE      = 2'b00;
    localparam READ_BITS = 2'b01;
    localparam CHECK_STOP= 2'b10;
    localparam RECOVER   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    wire receive_enable = (state == READ_BITS);

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter increments only during READ_BITS, resets at start of READ_BITS and reset
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && in == 1'b0) // start bit detected
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
        else
            bit_count <= bit_count; // hold otherwise
    end

    // Shift register shifts left to insert LSB first bit at LSB
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0) // start bit detected, clear shift reg
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {data_shift[6:0], in};
    end

    // done and out_byte register
    // done pulses high one cycle when stop bit is valid (in == 1 at CHECK_STOP)
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low
            if (state == CHECK_STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = IDLE; // safe default

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = READ_BITS; // start bit detected
                else
                    next_state = IDLE;
            end

            READ_BITS: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP; // all data bits received
                else
                    next_state = READ_BITS;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;     // valid stop bit, ready for next byte
                else
                    next_state = RECOVER;  // invalid stop bit, wait for idle
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;     // line idle regained
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule