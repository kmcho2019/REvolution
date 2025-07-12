module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE      = 4'b0001,
               START     = 4'b0010,
               DATA      = 4'b0100,
               WAIT_STOP = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_count;       // Counts 0 to 7 for data bits
    reg [7:0] shift_reg;       // Shift register to hold received data (not outputted here)
    reg data_enable;

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            shift_reg  <= 8'd0;
            done       <= 1'b0;
            data_enable <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default done low

            // Update bit_count and shift_reg only when data_enable is asserted
            if (data_enable) begin
                // Shift right: data bit goes into MSB, shifting rest right
                // This accumulates bits LSB-first over time:
                // First bit is bit 0 (LSB), last is bit 7 (MSB)
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end

            // Clear bit_count and shift_reg when entering IDLE
            if (next_state == IDLE) begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end
        end
    end

    // Next state logic and control signals combinational
    always @(*) begin
        // Defaults
        next_state = state;
        data_enable = 1'b0;

        case (state)
            IDLE: begin
                // Line is idle high, wait for start bit 0
                done = 1'b0;
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // Confirm start bit by sampling one clock after detection (can be immediate here)
                // Proceed to DATA to receive 8 bits
                next_state = DATA;
                data_enable = 1'b1;
            end

            DATA: begin
                data_enable = 1'b1;
                if (bit_count == 3'd7) begin
                    // Received last data bit, next cycle expects stop bit
                    next_state = WAIT_STOP;
                end else begin
                    next_state = DATA;
                end
            end

            WAIT_STOP: begin
                // Check stop bit: must be 1
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Framing error: stay here until stop bit detected
                    next_state = WAIT_STOP;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule