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

    // State encoding
    parameter IDLE     = 2'b00;
    parameter SHIFT    = 2'b01;
    parameter COUNTING = 2'b10;
    parameter DONE     = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;
    reg pattern_detected;

    // Pattern detection (only in IDLE state)
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0;
            pattern_detected <= 1'b0;
        end else begin
            if (state == IDLE) begin
                pattern <= {pattern[2:0], data};
                pattern_detected <= (pattern == 4'b1101);
            end else begin
                pattern <= 4'b0;
                pattern_detected <= 1'b0;
            end
        end
    end

    // Shift counter
    always @(posedge clk) begin
        if (reset) begin
            shift_cnt <= 2'b0;
        end else if (state == SHIFT) begin
            shift_cnt <= shift_cnt + 1;
        end else begin
            shift_cnt <= 2'b0;
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:     next_state = pattern_detected ? SHIFT : IDLE;
            SHIFT:    next_state = (shift_cnt == 2'b11) ? COUNTING : SHIFT;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE:     next_state = ack ? IDLE : DONE;
            default:  next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule