module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding (4 states)
    localparam [3:0]
        IDLE       = 4'b0001,
        RECEIVE    = 4'b0010,
        CHECK_STOP = 4'b0100,
        RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Enable signal for shifting and counting only in RECEIVE state
    wire shift_enable = (state == RECEIVE);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0;  // Default done low

            case (state)
                IDLE: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in LSB first when enabled
                    if (shift_enable) begin
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_cnt   <= bit_cnt + 3'd1;
                    end
                end

                CHECK_STOP: begin
                    bit_cnt <= 3'd0;
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end

                RECOVER: begin
                    bit_cnt <= 3'd0;
                    // No shift_reg update needed; wait for stop bit on line
                end

                default: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Combinational next state logic (one-hot FSM)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
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