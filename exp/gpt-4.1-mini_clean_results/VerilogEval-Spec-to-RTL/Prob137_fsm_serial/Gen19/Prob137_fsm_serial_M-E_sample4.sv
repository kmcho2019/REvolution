module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Binary encoded states
    localparam [1:0]
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        STOP_CHECK = 2'b10,
        ERROR      = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] bit_count;          // Counts data bits received (0 to 7)
    reg [7:0] data_shift_reg;     // Shift register to accumulate data bits

    // Next state logic and done generation
    always @(*) begin
        done = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                // Wait for start bit (line goes low)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 4'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1) begin
                    // Correct stop bit
                    next_state = IDLE;
                    done = 1'b1;
                end else begin
                    // Framing error - wait for line to idle
                    next_state = ERROR;
                end
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, bit counter, shift register, done
    always @(posedge clk) begin
        if (reset) begin
            state          <= IDLE;
            bit_count      <= 4'd0;
            data_shift_reg <= 8'd0;
            done           <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    bit_count <= 4'd0;
                    data_shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in bits LSB first: shift right, input bit goes into MSB
                    // But since protocol sends LSB first, shift right and put bit into MSB is opposite.
                    // Instead, shift left and put bit into LSB.
                    data_shift_reg <= {in, data_shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP_CHECK: begin
                    // done signal generated combinationally and assigned in this clock cycle
                    // No other updates needed here
                end

                ERROR: begin
                    // Hold current bit_count and data_shift_reg values
                end

                default: begin
                    bit_count <= 4'd0;
                    data_shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule