module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam STOP    = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;    // counts 0..7 data bits
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // default done low

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        bit_count  <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in data bits LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count  <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin // valid stop bit
                        out_byte <= data_shift;
                        done     <= 1'b1;
                    end
                    // else wait here until in returns to 1 (valid stop)
                end

                default: ;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;  // next byte possible
                else
                    next_state = STOP;  // wait for stop bit valid
            end

            default: next_state = IDLE;
        endcase
    end

endmodule