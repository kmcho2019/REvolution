module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Binary state encoding
    localparam IDLE       = 2'd0;
    localparam READ_BITS  = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam ERROR_WAIT = 2'd3;

    reg [1:0] state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    wire read_enable = (state == READ_BITS);

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with enable (count bits 0 to 7)
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (read_enable)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register shifts left; new serial bit goes into LSB (bit 0)
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (read_enable)
            shift_reg <= {in, shift_reg[7:1]};
        else if (state == IDLE)
            shift_reg <= 8'd0;
    end

    // done pulse and output register logic
    reg done_next;
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= done_next;
            if (done_next)
                out_byte <= shift_reg;
        end
    end

    // Combinational logic: next state and done pulse generation
    always @(*) begin
        next_state = state;
        done_next = 1'b0;

        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = READ_BITS;
                else
                    next_state = IDLE;
            end

            READ_BITS: begin
                // Collect 8 bits serially
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = READ_BITS;
            end

            CHECK_STOP: begin
                // Check stop bit (should be 1)
                if (in == 1'b1) begin
                    done_next = 1'b1;
                    next_state = IDLE;
                end else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                // Wait here until line returns idle (stop bit = 1)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule