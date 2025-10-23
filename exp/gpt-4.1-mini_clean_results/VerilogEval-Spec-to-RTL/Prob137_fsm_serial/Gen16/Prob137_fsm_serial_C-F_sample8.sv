module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM state encoding
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Detect start bit: line goes low (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, proceed to check stop bit
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                // If stop bit is correct (1), go to IDLE; else wait for a proper stop bit
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Stay here until stop bit (1) is detected
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0; pulse high for one clock cycle on successful byte reception
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Reset bit counter and shift register in IDLE for fresh start
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift left, serial input bit enters at LSB (bit 0)
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // If stop bit is correct, pulse done high once
                    if (in == 1'b1)
                        done <= 1'b1;

                    // Reset bit_count for next byte reception
                    bit_count <= 3'd0;
                end

                WAIT_STOP: begin
                    // Hold bit_count and shift_reg stable, reset to zero to reduce toggling
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule