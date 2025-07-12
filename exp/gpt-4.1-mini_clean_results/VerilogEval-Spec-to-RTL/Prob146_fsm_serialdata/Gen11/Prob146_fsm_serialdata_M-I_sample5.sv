module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding (4 states)
    localparam IDLE       = 4'b0001;
    localparam READ_BITS  = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] data_shift;
    reg bit_cnt_en, data_shift_en;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with enable
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (bit_cnt_en)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Data shift register with enable, shift LSB first: shift right and insert bit at MSB
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (data_shift_en)
            data_shift <= {in, data_shift[7:1]};
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // Done pulse and output byte
    // Done pulses one cycle on valid stop bit detection
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default low
            if (state == CHECK_STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= data_shift;
            end
        end
    end

    // Next state logic and control enables
    always @(*) begin
        // Defaults
        next_state = state;
        bit_cnt_en = 1'b0;
        data_shift_en = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = READ_BITS;
                    bit_cnt_en = 1'b1;
                    data_shift_en = 1'b1;
                end else begin
                    next_state = IDLE;
                end
            end

            READ_BITS: begin
                bit_cnt_en = 1'b1;
                data_shift_en = 1'b1;
                if (bit_cnt == 3'd7) begin
                    next_state = CHECK_STOP;
                end else begin
                    next_state = READ_BITS;
                end
            end

            CHECK_STOP: begin
                // If valid stop bit, go back to IDLE
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            RECOVER: begin
                // Stay in recover until line returns to idle (1)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule