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

    // One-hot state encoding
    parameter IDLE     = 4'b0001;
    parameter SHIFT    = 4'b0010;
    parameter COUNTING = 4'b0100;
    parameter DONE     = 4'b1000;

    reg [3:0] state, next_state;
    reg [3:0] pattern;
    reg [1:0] shift_ctr;  // Only need 2 bits to count 0-3

    // Continuous pattern detection and state transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            shift_ctr <= 2'b0;
        end else begin
            state <= next_state;
            
            // Always shift in new data for continuous pattern detection
            pattern <= {pattern[2:0], data};
            
            // Shift counter logic (counts 0-3)
            if (state == SHIFT) begin
                shift_ctr <= shift_ctr + 1;
            end else begin
                shift_ctr <= 2'b0;
            end
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:     next_state = (pattern == 4'b1101) ? SHIFT : IDLE;
            SHIFT:    next_state = (shift_ctr == 2'b11) ? COUNTING : SHIFT;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE:     next_state = ack ? IDLE : DONE;
            default:  next_state = IDLE;
        endcase
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule