module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // FSM state encoding (binary)
    localparam IDLE       = 2'd0;
    localparam READ_BITS  = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam RECOVER    = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] data_shift;
    reg       done_next;

    wire read_enable = (state == READ_BITS);

    // Sequential logic: state, bit counter, shift register, output, done
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_cnt    <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done_next;

            if (read_enable) begin
                bit_cnt <= bit_cnt + 3'd1;
                // Shift right, LSB first reception: input goes to MSB
                data_shift <= {in, data_shift[7:1]};
            end else begin
                bit_cnt <= 3'd0;
                if (state == IDLE) begin
                    data_shift <= 8'd0;
                end
            end

            if (done_next) begin
                out_byte <= data_shift;
            end
        end
    end

    // Combinational next-state and done signal logic
    always @(*) begin
        next_state = state;
        done_next  = 1'b0;

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
                    done_next = 1'b1; // valid stop bit, pulse done
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