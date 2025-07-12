module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Binary-encoded FSM states
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)       // Detect start bit (0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7) // After 8 bits received
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)       // Correct stop bit
                    next_state = IDLE;
                else                  // Framing error
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)       // Wait for stop bit
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

            // Default done to 0; pulse one cycle at CHECK_STOP if stop bit correct
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift left by 1, insert new bit at LSB (LSB first)
                    // This correctly places the first received data bit in shift_reg[0].
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // Assert done if stop bit is correct
                    if (in == 1'b1)
                        done <= 1'b1;
                    bit_count <= 3'd0;
                end

                WAIT_STOP: begin
                    // Wait until stop bit detected; hold counters and shift_reg stable to reduce toggling
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule