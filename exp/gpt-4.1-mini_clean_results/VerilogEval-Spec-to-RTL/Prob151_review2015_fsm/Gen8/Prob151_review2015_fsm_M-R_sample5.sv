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

    // One-hot state encoding for clarity
    typedef enum logic [3:0] {
        IDLE  = 4'b0001,
        SHIFT = 4'b0010,
        COUNT = 4'b0100,
        DONE  = 4'b1000
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (only shift in IDLE)
    reg [3:0] pattern_shift;

    // Shift counter for SHIFT state (0 to 3)
    reg [1:0] shift_count;

    // Pattern to detect
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state, pattern_shift, shift_count
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;

            // Shift pattern_shift only in IDLE to detect pattern
            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                pattern_shift <= 4'd0; // Clear pattern shift when not in IDLE
            end

            // Shift count increments only in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @* begin
        next_state = state; // Default hold

        case (state)
            IDLE: begin
                if (pattern_shift == PATTERN)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = COUNT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Outputs driven by state (Moore outputs)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule