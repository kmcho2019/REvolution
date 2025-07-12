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

    // State encoding with explicit values
    typedef enum logic [2:0] {
        SEARCH    = 3'b000,
        SHIFT1    = 3'b001,
        SHIFT2    = 3'b010,
        SHIFT3    = 3'b011,
        SHIFT4    = 3'b100,
        COUNTING  = 3'b101,
        COMPLETE  = 3'b110,
        WATCHDOG  = 3'b111
    } state_t;

    state_t current_state, next_state;
    reg [3:0] pattern_window;
    reg [1:0] timeout_counter;

    // Pattern detection and state transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= SEARCH;
            pattern_window <= 4'b0;
            timeout_counter <= 2'b0;
        end else begin
            current_state <= next_state;
            
            // Update pattern window
            pattern_window <= {pattern_window[2:0], data};
            
            // Watchdog timer
            if (timeout_counter == 2'b11)
                next_state <= WATCHDOG;
            else
                timeout_counter <= timeout_counter + 1;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            SEARCH: begin
                next_state = (pattern_window == 4'b1101) ? SHIFT1 : SEARCH;
                timeout_counter = 2'b0;
            end
            
            SHIFT1: next_state = SHIFT2;
            SHIFT2: next_state = SHIFT3;
            SHIFT3: next_state = SHIFT4;
            SHIFT4: next_state = COUNTING;
            
            COUNTING: begin
                next_state = done_counting ? COMPLETE : COUNTING;
                timeout_counter = 2'b0;
            end
            
            COMPLETE: next_state = ack ? SEARCH : COMPLETE;
            
            WATCHDOG: next_state = SEARCH;  // Auto-recover on timeout
            
            default: next_state = SEARCH;
        endcase
    end

    // Output logic (registered for clean transitions)
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            shift_ena <= (current_state inside {SHIFT1, SHIFT2, SHIFT3, SHIFT4});
            counting <= (current_state == COUNTING);
            done <= (current_state == COMPLETE);
        end
    end

endmodule