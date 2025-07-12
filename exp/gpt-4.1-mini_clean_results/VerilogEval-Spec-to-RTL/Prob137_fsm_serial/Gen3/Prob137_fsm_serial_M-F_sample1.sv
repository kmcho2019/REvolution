module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot encoded FSM states
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;       // 3-bit counter for 0-7 bits
    reg [7:0] shift_reg;       // 8-bit shift register for data bits

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0 each clock
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                RECEIVE: begin
                    // Shift in new bit into LSB (LSB first), shift register shifts right
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                CHECK_STOP: begin
                    // Assert done if stop bit (in) is correct
                    if (in == 1'b1)
                        done <= 1'b1;
                    bit_count <= 3'd0;    // Reset bit count regardless
                end
                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    // Clear shift_reg optional; keep for consistency
                    shift_reg <= 8'd0;
                end
                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)  // After receiving 8 bits
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end
            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Correct stop bit, go idle
                else
                    next_state = WAIT_STOP;  // Wait for stop bit
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule