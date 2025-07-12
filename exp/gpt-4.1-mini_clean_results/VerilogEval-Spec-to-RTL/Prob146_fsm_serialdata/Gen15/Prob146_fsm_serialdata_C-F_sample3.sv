module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding
    localparam [1:0]
        IDLE      = 2'b00,
        RECEIVE   = 2'b01,
        CHECK_STOP= 2'b10,
        RECOVER   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Sequential logic: state, bit counter, shift reg, done, out_byte
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low each cycle

            case (state)
                IDLE: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right, LSB first: new bit enters MSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt   <= bit_cnt + 3'd1;
                end

                CHECK_STOP: begin
                    bit_cnt <= 3'd0; // reset counter for next frame
                    if (in == 1'b1) begin
                        done     <= 1'b1;
                        out_byte <= shift_reg;
                    end
                end

                RECOVER: begin
                    bit_cnt <= 3'd0;
                    // Hold shift_reg stable to reduce toggling
                    shift_reg <= shift_reg;
                end

                default: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
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