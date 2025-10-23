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
    localparam RECOVER    = 2'd3;

    reg [1:0] state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] data_shift;

    wire read_enable = (state == READ_BITS);

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
        else if (read_enable)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Data shift register with enable, shift right to put LSB first into data_shift[0]
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (read_enable)
            data_shift <= {in, data_shift[7:1]};
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // done pulse generation and out_byte register
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

    // Combinational next state and done pulse logic
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
                if (bit_cnt == 3'd7)
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