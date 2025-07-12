module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // Define states with proper encoding
    localparam [1:0] 
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] shift_counter;
    reg [3:0] pattern_reg;  // Shift register for pattern detection

    // State transition and pattern detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 0;
            pattern_reg <= 4'b0;
        end else begin
            current_state <= next_state;
            
            // Update pattern detection shift register in all states
            pattern_reg <= {pattern_reg[2:0], data};
            
            // Counter for SHIFT state only
            if (current_state == SHIFT) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                // Only check pattern in IDLE state
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            
            SHIFT: begin
                if (shift_counter == 2'b11) begin  // After 4 cycles (0-3)
                    next_state = COUNTING;
                end else begin
                    next_state = SHIFT;
                end
            end
            
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNTING;
                end
            end
            
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Output logic - registered for clean timing
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            shift_ena <= (next_state == SHIFT);
            counting <= (next_state == COUNTING);
            done <= (next_state == DONE);
        end
    end

endmodule