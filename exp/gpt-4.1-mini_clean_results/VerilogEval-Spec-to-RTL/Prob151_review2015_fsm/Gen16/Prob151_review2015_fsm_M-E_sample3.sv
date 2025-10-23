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

    // One-hot state encoding
    localparam S_SEARCH   = 4'b0001;
    localparam S_SHIFT    = 4'b0010;
    localparam S_COUNT    = 4'b0100;
    localparam S_DONE     = 4'b1000;

    reg [3:0] state, next_state;

    // Shift register to hold last 4 bits for pattern detection
    reg [3:0] pattern_shift;

    // Counter for 4 shift cycles
    reg [2:0] shift_counter;

    // Pattern to detect: 1101 binary = 4'b1101
    wire pattern_detected = (pattern_shift == 4'b1101);

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            pattern_shift <= 4'b0000;
            shift_counter <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            if (state == S_SEARCH) begin
                // Shift in new data bit for pattern detection
                pattern_shift <= {pattern_shift[2:0], data};
                done <= 1'b0;
            end else begin
                // Maintain pattern_shift when not searching
                pattern_shift <= pattern_shift;
            end

            if (state == S_SHIFT) begin
                shift_counter <= shift_counter + 3'd1;
            end else begin
                shift_counter <= 3'd0;
            end

            // Set done output only when entering DONE state
            if (next_state == S_DONE)
                done <= 1'b1;
            else if (state == S_DONE && ack)
                done <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default stay

        case (state)
            S_SEARCH: begin
                if (pattern_detected)
                    next_state = S_SHIFT;
            end

            S_SHIFT: begin
                if (shift_counter == 3'd3) // after 4 shift cycles (0..3)
                    next_state = S_COUNT;
            end

            S_COUNT: begin
                if (done_counting)
                    next_state = S_DONE;
            end

            S_DONE: begin
                if (ack)
                    next_state = S_SEARCH;
            end
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        shift_ena = (state == S_SHIFT);
        counting  = (state == S_COUNT);
        // done is registered, controlled in sequential always block
    end

endmodule