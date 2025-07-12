module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Expanded states to clearly track protocol phases
    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        RECEIVING = 2'b01,
        STOP     = 2'b10
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_counter;  // Counts 0-7 (8 data bits)
    reg [7:0] shift_reg;

    // State transition and data capture
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;  // Default done to 0

            case (state)
                IDLE: begin
                    bit_counter <= 0;
                    shift_reg <= 0;
                end
                
                RECEIVING: begin
                    // Shift in data bits (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_counter == 7) begin
                        bit_counter <= 0;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVING : IDLE;
            end
            
            RECEIVING: begin
                if (bit_counter == 7) begin
                    next_state = STOP;  // Move to stop bit check
                end else begin
                    next_state = RECEIVING;  // Keep receiving
                end
            end
            
            STOP: begin
                if (in) begin
                    next_state = IDLE;  // Valid stop bit, return to idle
                end else begin
                    next_state = STOP;  // Wait for valid stop bit
                end
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule