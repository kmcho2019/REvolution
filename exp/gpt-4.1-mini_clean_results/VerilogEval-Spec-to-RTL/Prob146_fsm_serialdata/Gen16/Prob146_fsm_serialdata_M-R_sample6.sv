module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        READ_BITS  = 2'b01,
        CHECK_STOP = 2'b10,
        RECOVER    = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_cnt;

    wire in_start = (in == 1'b0);
    wire in_stop  = (in == 1'b1);
    wire read_en  = (state == READ_BITS);

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = in_start ? READ_BITS : IDLE;

            READ_BITS: 
                next_state = (bit_cnt == 3'd7) ? CHECK_STOP : READ_BITS;

            CHECK_STOP: 
                next_state = in_stop ? IDLE : RECOVER;

            RECOVER: 
                next_state = in_stop ? IDLE : RECOVER;

            default: 
                next_state = IDLE;
        endcase
    end

    // Bit counter with enable and reset
    always @(posedge clk) begin
        if (reset || state != READ_BITS)
            bit_cnt <= 3'd0;
        else if (read_en)
            bit_cnt <= bit_cnt + 3'd1;
    end

    // Shift register capturing LSB first
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (read_en)
            data_shift <= {in, data_shift[7:1]};
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // Output registers
    // done asserted only when a correct stop bit is detected at CHECK_STOP state
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default done low
            if (state == CHECK_STOP && in_stop) begin
                done <= 1'b1;
                out_byte <= data_shift;
            end
        end
    end

endmodule