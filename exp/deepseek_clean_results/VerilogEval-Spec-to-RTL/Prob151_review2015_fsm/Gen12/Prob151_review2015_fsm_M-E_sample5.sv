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

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        SHIFT,
        COUNT,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Pattern detection window
    reg [3:0] data_window;
    wire pattern_match = (data_window == 4'b1101);

    // Shift counter (counts down 3->0 for 4 cycles)
    reg [1:0] shift_counter;

    // Output registers
    reg shift_ena_next, counting_next, done_next;

    // Data window shift register
    always @(posedge clk) begin
        if (reset) begin
            data_window <= 4'b0;
        end else begin
            data_window <= {data_window[2:0], data};
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
            shift_counter <= 2'b11; // Initialize to 3 (counts 3,2,1,0)
        end else begin
            current_state <= next_state;
            shift_ena <= shift_ena_next;
            counting <= counting_next;
            done <= done_next;

            // Shift counter logic
            if (current_state == SHIFT) begin
                shift_counter <= shift_counter - 1'b1;
            end else begin
                shift_counter <= 2'b11; // Reset to 3
            end
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default outputs
        shift_ena_next = 1'b0;
        counting_next = 1'b0;
        done_next = 1'b0;
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (pattern_match) begin
                    next_state = SHIFT;
                    shift_ena_next = 1'b1; // Assert immediately
                end
            end

            SHIFT: begin
                shift_ena_next = 1'b1; // Keep asserted
                if (shift_counter == 2'b00) begin // After 4 cycles
                    next_state = COUNT;
                end
            end

            COUNT: begin
                counting_next = 1'b1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                done_next = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule