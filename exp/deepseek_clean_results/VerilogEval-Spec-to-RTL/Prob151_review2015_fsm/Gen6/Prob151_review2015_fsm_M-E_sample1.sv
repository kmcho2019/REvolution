module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // Explicit state encoding
    localparam [2:0]
        IDLE       = 3'b000,
        SHIFT_DELAY = 3'b001,
        COUNTING    = 3'b010,
        NOTIFY      = 3'b100;

    reg [2:0] state, next_state;
    reg [1:0] shift_count;
    reg [3:0] pattern_buffer;

    // Pattern detection shift register (shifts continuously)
    always @(posedge clk) begin
        if (reset) begin
            pattern_buffer <= 4'b0;
        end else begin
            pattern_buffer <= {pattern_buffer[2:0], data};
        end
    end

    // Shift counter (active only during SHIFT_DELAY)
    always @(posedge clk) begin
        if (reset) begin
            shift_count <= 2'b0;
        end else if (state == SHIFT_DELAY) begin
            shift_count <= shift_count + 1;
        end else begin
            shift_count <= 2'b0;
        end
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic with edge detection
    always @(*) begin
        case (state)
            IDLE:
                next_state = (pattern_buffer == 4'b1101) ? SHIFT_DELAY : IDLE;

            SHIFT_DELAY:
                next_state = (shift_count == 2'b11) ? COUNTING : SHIFT_DELAY;

            COUNTING:
                next_state = done_counting ? NOTIFY : COUNTING;

            NOTIFY:
                next_state = ack ? IDLE : NOTIFY;

            default:
                next_state = IDLE;
        endcase
    end

    // Output generation with clean timing
    assign shift_ena = (state == SHIFT_DELAY);
    assign counting = (state == COUNTING);
    assign done = (state == NOTIFY);

endmodule