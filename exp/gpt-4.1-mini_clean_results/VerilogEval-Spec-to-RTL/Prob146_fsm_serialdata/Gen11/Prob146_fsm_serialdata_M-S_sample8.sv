module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding
    localparam [1:0]
        IDLE    = 2'b00,
        RECEIVE = 2'b01,
        STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;      // 3-bit counter for 8 bits
    reg [7:0] data_shift;

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
            bit_cnt <= 3'd0;
        else if (state == RECEIVE)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: shift left and place new bit at LSB for LSB-first protocol
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == RECEIVE)
            data_shift <= {in, data_shift[7:1]};
    end

    // done signal and out_byte latch
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else if (state == STOP && in == 1'b1) begin
            done <= 1'b1;
            out_byte <= data_shift;
        end else begin
            done <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;  // start bit detected
            end
            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;     // 8 data bits received
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;     // valid stop bit, go back to idle
                // else remain in STOP waiting for valid stop bit (line idle)
            end
            default: next_state = IDLE;
        endcase
    end

endmodule