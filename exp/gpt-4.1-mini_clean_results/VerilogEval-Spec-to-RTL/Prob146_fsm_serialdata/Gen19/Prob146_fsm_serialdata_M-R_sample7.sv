module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam START_BIT  = 4'b0010;
    localparam DATA_BITS  = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter and shift register
    always @(posedge clk) begin
        if (reset) begin
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            case(state)
                START_BIT: begin
                    // Wait one clock cycle for start bit detection (already detected in IDLE)
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end
                DATA_BITS: begin
                    // Shift in LSB first (new bit into MSB, shift left)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end
                default: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= shift_reg; // Hold value
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Wait for start bit (line goes low)
                if (in == 1'b0)
                    next_state = START_BIT;
            end
            START_BIT: begin
                // After start bit cycle, move to data bits
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_cnt == 3'd7) begin
                    // After 8 bits, check stop bit next cycle
                    next_state = (in == 1'b1) ? IDLE : RECOVER;
                end
            end
            RECOVER: begin
                // Wait for line idle (stop bit) before returning to IDLE
                if (in == 1'b1)
                    next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default done low

            if (state == DATA_BITS && bit_cnt == 3'd7) begin
                // At last data bit, wait one cycle for stop bit in same cycle as next_state check
                // So done asserted in next cycle if stop bit valid (in DATA_BITS here)
                // Adjust done assertion to next state transition (IDLE after stop bit detected)
                // Thus, done asserted on transition from DATA_BITS to IDLE if stop bit valid
                // Implement done in next cycle by checking state transition

                // To catch done pulse in cycle after stop bit validation, latch a flag
                // Here, done will be asserted in cycle when state == IDLE and prev state DATA_BITS with valid stop bit
                // For simplicity, done asserted one cycle when returning to IDLE from DATA_BITS if stop bit was 1

                // This logic moved to below
            end

            // Assert done only on state change from DATA_BITS to IDLE (valid stop bit)
            if (state == IDLE && next_state == IDLE) begin
                // no transition, no done
                done <= 1'b0;
            end else if (state == DATA_BITS && next_state == IDLE && in == 1'b1) begin
                // Valid stop bit detected at DATA_BITS end, done pulse here
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

endmodule