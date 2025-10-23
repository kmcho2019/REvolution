module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam [1:0]
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        RECOVER    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

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

            // Default done low, asserted only for one cycle when stop bit valid
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in LSB first: right shift, new bit into MSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;
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
                    // no need to hold shift_reg, reset and wait for idle
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (in == 1'b0) ? RECEIVE : IDLE;

            RECEIVE: 
                next_state = (bit_cnt == 3'd7) ? CHECK_STOP : RECEIVE;

            CHECK_STOP: 
                next_state = (in == 1'b1) ? IDLE : RECOVER;

            RECOVER:
                next_state = (in == 1'b1) ? IDLE : RECOVER;

            default:
                next_state = IDLE;
        endcase
    end

endmodule