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

    // Bit counter increments only during READ_BITS, resets otherwise
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
        else
            bit_count <= 3'd0;
    end

    // Shift register loads zero at IDLE->READ_BITS transition (start bit detected)
    // Shift left on receive_enable, new serial bit loaded at LSB to match LSB-first protocol
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {data_shift[6:0], in};
    end

    // done_next combinational signal to pulse done for one cycle after valid stop bit
    reg done_next;
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= done_next;
            if (done_next)
                out_byte <= data_shift;
        end
    end

    // Combinational next state and done_next logic
    always @(*) begin
        next_state = state;
        done_next = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = READ_BITS;
                else
                    next_state = IDLE;
            end

            READ_BITS: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = READ_BITS;
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    done_next = 1'b1;
                    next_state = IDLE;
                end else
                    next_state = RECOVER;
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule