module TopModule(
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding
    typedef enum logic [2:0] {
        WAIT_START    = 3'b000,
        READ_BITS     = 3'b001,
        WAIT_STOP     = 3'b010,
        ERROR_RECOVERY= 3'b011,
        OUTPUT        = 3'b100
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt;      // Count bits 0..7
    reg [7:0] shift_reg;    // Shift register for data bits

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_START;
        else
            state <= next_state;
    end

    // Bit counter register
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == READ_BITS)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: Shift left, new bit at LSB (since serial LSB first)
    // For LSB first, we place new bit at shift_reg[0], shift existing left
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == READ_BITS)
            shift_reg <= {in, shift_reg[7:1]}; // MSB on left, shift right to keep LSB first (same as before)
        else if (state == WAIT_START)
            shift_reg <= 8'd0;
    end

    // Done and output logic, asserted for one cycle in OUTPUT state
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else if (state == OUTPUT) begin
            done <= 1'b1;
            out_byte <= shift_reg;
        end else begin
            done <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WAIT_START: begin
                // Idle line is high; start bit = 0 detected
                if (in == 1'b0)
                    next_state = READ_BITS;
                else
                    next_state = WAIT_START;
            end

            READ_BITS: begin
                // After receiving 8 bits go to stop bit check
                if (bit_cnt == 3'd7)
                    next_state = WAIT_STOP;
                else
                    next_state = READ_BITS;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = OUTPUT;         // Valid stop bit
                else
                    next_state = ERROR_RECOVERY; // Invalid stop bit
            end

            ERROR_RECOVERY: begin
                // Wait for line to return to idle (1)
                if (in == 1'b1)
                    next_state = WAIT_START;
                else
                    next_state = ERROR_RECOVERY;
            end

            OUTPUT: begin
                // After done output cycle, return to wait for next start bit
                next_state = WAIT_START;
            end

            default: next_state = WAIT_START;
        endcase
    end

endmodule