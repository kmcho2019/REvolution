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

    // Explicit state encoding
    typedef enum logic [2:0] {
        S_IDLE,
        S_WAIT,
        S_SHIFT,
        S_COUNT,
        S_DONE
    } state_t;

    reg [2:0] current_state, next_state;
    reg [1:0] shift_counter;
    reg [3:0] pattern_buffer;

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_buffer <= 4'b0;
        end else begin
            pattern_buffer <= {pattern_buffer[2:0], data};
        end
    end

    // Pattern edge detection
    wire pattern_detected = (pattern_buffer == 4'b1101);

    // Shift counter (modulo-4)
    always @(posedge clk) begin
        if (reset || current_state != S_SHIFT) begin
            shift_counter <= 2'b0;
        end else begin
            shift_counter <= shift_counter + 1;
        end
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        
        case (current_state)
            S_IDLE: 
                if (pattern_detected)
                    next_state = S_WAIT;
            
            S_WAIT:
                next_state = S_SHIFT;
            
            S_SHIFT:
                if (shift_counter == 2'b11)  // After 4 cycles (0-3)
                    next_state = S_COUNT;
            
            S_COUNT:
                if (done_counting)
                    next_state = S_DONE;
            
            S_DONE:
                if (ack)
                    next_state = S_IDLE;
        endcase
    end

    // Registered output logic
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            shift_ena <= (next_state == S_SHIFT);
            counting <= (next_state == S_COUNT);
            done <= (next_state == S_DONE);
        end
    end

endmodule