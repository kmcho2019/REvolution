module TopModule (
    input wire clk,
    input wire in,
    input wire reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE     = 2'b00,
        DATA     = 2'b01,
        STOP     = 2'b10,
        WAIT_STOP= 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Sequential: State, counters, shift register, outputs
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Clear done by default; it pulses high for 1 cycle on valid stop bit
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                    // no done here
                end

                DATA: begin
                    // Shift in LSB first: shift right, new bit into MSB to LSB ordering is reversed
                    // We want LSB first -> shift right, newest bit into MSB
                    // But to keep LSB first order in shift_reg, shift left, new bit at LSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit: latch out_byte and pulse done
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    // bit_cnt reset for next frame
                    bit_cnt <= 3'd0;
                end

                WAIT_STOP: begin
                    // Nothing changes until stop bit detected
                    // Keep shift_reg and bit_cnt unchanged
                end
            endcase
        end
    end

    // Combinational: next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;  // Start bit detected
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP; // After last data bit, check stop bit
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // Valid stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // Invalid stop bit, wait for stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // Stop bit detected, ready again
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule