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

    // Bit counter increments only during READ_BITS, reset on reset or start bit detection
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && in == 1'b0)
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
    end

    // Shift register shifts left, inserting new bit at LSB, only during READ_BITS
    // On start bit detected (IDLE and in==0), clear data_shift to zero
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {in, data_shift[7:1]}; // original was MSB<-in, we change below to LSB<-in
    end

    // Correct the shift: shift left with new bit on LSB (in serial LSB first)
    // So new data_shift = {data_shift[6:0], in}
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {data_shift[6:0], in};
    end

    // done and out_byte registers, assert done one cycle on valid stop bit detection
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (state == CHECK_STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold state

        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = READ_BITS;  // start bit detected
            end

            READ_BITS: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP; // all 8 data bits received
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // valid stop bit, ready for next byte
                else
                    next_state = RECOVER;    // invalid stop bit, wait for idle
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;       // line idle regained
            end

            default: next_state = IDLE;
        endcase
    end

endmodule