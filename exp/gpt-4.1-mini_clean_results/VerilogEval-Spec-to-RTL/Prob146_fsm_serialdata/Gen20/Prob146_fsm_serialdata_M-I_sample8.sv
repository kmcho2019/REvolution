module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot encoded FSM states
    localparam IDLE       = 4'b0001;
    localparam READ_BITS  = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Next-state logic combinational
    always @(*) begin
        next_state = IDLE;  // default
        case(state)
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

    // Sequential logic: state, shift_reg, bit_cnt, out_byte, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done deassert

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                READ_BITS: begin
                    // Shift LSB first: shift right, input bit becomes MSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1; // pulse done for 1 cycle
                    end
                end

                RECOVER: begin
                    // wait for line to become idle (stop bit 1)
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule