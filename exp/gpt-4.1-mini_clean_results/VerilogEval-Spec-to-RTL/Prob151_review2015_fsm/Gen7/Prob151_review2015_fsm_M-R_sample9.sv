module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // State encoding using one-hot style for clarity
    typedef enum logic [1:0] {
        IDLE  = 2'b00, // waiting for pattern detection
        SHIFT = 2'b01, // shifting 4 bits
        COUNT = 2'b10, // waiting for counting done
        DONE  = 2'b11  // done, wait for ack
    } state_t;

    state_t state, next_state;

    // 4-bit shift register to detect pattern '1101' on data input
    reg [3:0] pattern_shift;

    // Shift counter for SHIFT state (counts 0..3)
    reg [1:0] shift_count;

    // Pattern detected when pattern_shift == 4'b1101
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Sequential logic: shift pattern register and state update
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            shift_count <= 2'd0;
        end else begin
            // Shift in serial data every clock
            pattern_shift <= {pattern_shift[2:0], data};

            // State update
            state <= next_state;

            // Shift count update in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait until pattern detected
                if (pattern_detected)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                // After 4 shift cycles move to COUNT
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                // Wait for done_counting
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                // Wait for ack, then return to IDLE and restart pattern detection
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output assignments (Moore outputs depend on state only)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule