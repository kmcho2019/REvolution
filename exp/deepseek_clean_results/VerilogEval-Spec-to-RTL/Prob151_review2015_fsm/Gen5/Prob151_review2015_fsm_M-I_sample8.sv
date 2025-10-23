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
    reg [3:0] pattern;
    reg [1:0] shift_ctr;
    reg pattern_detected;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            shift_ctr <= 2'b0;
            pattern_detected <= 1'b0;
        end else begin
            state <= next_state;
            
            // Continuous pattern detection in IDLE state
            if (state == IDLE) begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    pattern_detected <= 1'b1;
                end
            end else begin
                pattern_detected <= 1'b0;
            end

            // Shift counter logic
            if (state == SHIFT) begin
                shift_ctr <= shift_ctr + 1;
            end else begin
                shift_ctr <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = pattern_detected ? SHIFT : IDLE;
            SHIFT: next_state = (shift_ctr == 2'b11) ? COUNTING : SHIFT;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule