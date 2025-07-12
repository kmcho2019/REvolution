module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // State encoding (binary)
    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        SHIFT  = 2'b01,
        COUNT  = 2'b10,
        DONE   = 2'b11
    } state_t;

    state_t state, next_state;

    // 4-bit shift register for pattern detection (shift in every clock)
    reg [3:0] data_shift;

    // Pattern to detect
    localparam [3:0] PATTERN = 4'b1101;

    // Detect pattern combinationally
    wire pattern_detected = (data_shift == PATTERN);

    // Shift enable counter (2 bits to count 4 cycles: 0 to 3)
    reg [1:0] shift_count;

    // Data shift register update - always shift in data every clock
    always @(posedge clk) begin
        if (reset) begin
            data_shift <= 4'b0;
        end else begin
            data_shift <= {data_shift[2:0], data};
        end
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH;
        else
            state <= next_state;
    end

    // shift_count register update: only counts in SHIFT state
    always @(posedge clk) begin
        if (reset)
            shift_count <= 2'd0;
        else if (state == SHIFT)
            shift_count <= shift_count + 2'd1;
        else
            shift_count <= 2'd0;
    end

    // Next state logic
    always @(*) begin
        // Default to hold state
        next_state = state;

        case (state)
            SEARCH: begin
                // Only detect pattern in SEARCH state to avoid repeated triggers
                if (pattern_detected)
                    next_state = SHIFT;
            end

            SHIFT: begin
                // After 4 cycles (shift_count 0..3), go to COUNT
                if (shift_count == 2'd3)
                    next_state = COUNT;
            end

            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Output logic registered with state and counters for glitch-free outputs
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            // shift_ena asserted only during SHIFT state
            shift_ena <= (state == SHIFT);
            // counting asserted only during COUNT state
            counting  <= (state == COUNT);
            // done asserted only during DONE state
            done      <= (state == DONE);
        end
    end

endmodule