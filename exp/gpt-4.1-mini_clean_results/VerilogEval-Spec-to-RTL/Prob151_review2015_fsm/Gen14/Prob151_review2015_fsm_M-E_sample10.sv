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

    // One-hot encoded states (5 states)
    localparam SEARCH  = 5'b00001;
    localparam SHIFT   = 5'b00010;
    localparam COUNT   = 5'b00100;
    localparam DONE    = 5'b01000;

    // We won't use the fifth bit here (left zero)
    // State register
    reg [4:0] state, next_state;

    // 4-bit shift register for pattern detection (serially shift input data)
    reg [3:0] pattern_shift;

    // 2-bit shift counter for SHIFT state cycles (0 to 3)
    reg [1:0] shift_count;

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            // Pattern detection shift register logic: only update in SEARCH
            if (state == SEARCH) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                pattern_shift <= 4'b0000; // clear outside SEARCH to avoid confusion
            end

            // shift_count increments only in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'b01;
            end else begin
                shift_count <= 2'b00;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Check if pattern_shift == 1101 (binary)
                if (pattern_shift == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                if (shift_count == 2'b11) begin // After 4 cycles (0..3)
                    next_state = COUNT;
                end
            end

            COUNT: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                if (ack) begin
                    next_state = SEARCH;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

    // Outputs (Moore)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule