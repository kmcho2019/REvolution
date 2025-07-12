module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RECEIVE = 2'd1,
        STOP    = 2'd2,
        RECOVER = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default no pulse

            case (state)
                IDLE: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right, new bit goes to MSB for LSB first protocol
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                end

                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end

                RECOVER: begin
                    // Stay here until line idle (high)
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 1'b0) ? RECEIVE : IDLE;  // start bit detected
            RECEIVE: next_state = (bit_cnt == 3'd7) ? STOP : RECEIVE;
            STOP:    next_state = (in == 1'b1) ? IDLE : RECOVER;
            RECOVER: next_state = (in == 1'b1) ? IDLE : RECOVER;
            default: next_state = IDLE;
        endcase
    end

endmodule