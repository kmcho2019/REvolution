module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RECEIVE = 2'b01,
        WAIT_STOP = 2'b10
    } state_t;

    state_t state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                        bit_cnt <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in LSB first: shift right, MSB gets new bit
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_cnt == 3'd7) begin
                        state <= WAIT_STOP;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        // valid stop bit: output data and assert done
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // invalid stop bit: wait here until line is 1 again
                        state <= WAIT_STOP;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule