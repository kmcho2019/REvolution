module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // States
    typedef enum logic {
        IDLE = 1'b0,
        ACTIVE = 1'b1
    } state_t;

    reg state, next_state;
    reg [3:0] bit_counter;  // Counts 0-8 (0-7 for data, 8 for stop)
    reg [7:0] shift_reg;
    reg stuck;  // Becomes 1 if we see invalid stop bit

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            shift_reg <= 0;
            stuck <= 0;
        end else begin
            state <= next_state;
            
            if (state == ACTIVE) begin
                if (bit_counter < 8) begin
                    // Shift in data bits (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_counter <= bit_counter + 1;
                end
                else if (in) begin
                    // Valid stop bit - load output and reset
                    out_byte <= shift_reg;
                    bit_counter <= 0;
                    stuck <= 0;
                end
                else begin
                    // Invalid stop bit - get stuck
                    stuck <= 1;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (in == 0) ? ACTIVE : IDLE;
            ACTIVE: begin
                if (bit_counter == 8 && in && !stuck)
                    next_state = IDLE;  // Proper byte end
                else if (bit_counter == 8 && stuck && in)
                    next_state = IDLE;  // Finally saw stop bit
                else
                    next_state = ACTIVE;  // Keep receiving
            end
            default: next_state = IDLE;
        endcase
    end

    // Done is combinational - asserted when we see valid stop bit
    assign done = (state == ACTIVE) && (bit_counter == 8) && in && !stuck;

endmodule