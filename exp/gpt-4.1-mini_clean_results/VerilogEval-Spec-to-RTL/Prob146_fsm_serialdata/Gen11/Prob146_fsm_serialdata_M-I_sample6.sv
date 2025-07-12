module TopModule(
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam STOP_WAIT  = 4'b0100;
    localparam ERROR_WAIT = 4'b1000;

    reg [3:0] state, next_state;

    reg [7:0] data_shift;
    reg [3:0] bit_count;

    // Next state logic - combinational
    always @(*) begin
        case(1'b1)
            state[0]: begin // IDLE
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            state[1]: begin // RECEIVE
                if (bit_count == 4'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end
            state[2]: begin // STOP_WAIT
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            state[3]: begin // ERROR_WAIT
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            data_shift <= 8'd0;
            bit_count  <= 4'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low each cycle
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_count  <= 4'd0;
                    data_shift <= 8'd0;
                    // no shifting or done here
                end

                RECEIVE: begin
                    // Shift left and insert LSB first protocol bit at LSB
                    // So new bit goes into LSB, shift existing data left by 1
                    data_shift <= {in, data_shift[7:1]};
                    bit_count  <= bit_count + 1;
                end

                STOP_WAIT: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end

                ERROR_WAIT: begin
                    // Wait here until stop bit is seen, no outputs or changes
                end
            endcase
        end
    end

endmodule