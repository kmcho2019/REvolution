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

    reg [3:0] state;
    reg [3:0] next_state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // Pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0;
        end else begin
            pattern <= {pattern[2:0], data};
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 0;
        end else begin
            state <= next_state;
            
            if (state == SHIFT) begin
                shift_cnt <= shift_cnt + 1;
            end else begin
                shift_cnt <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:     next_state = (pattern == 4'b1101) ? SHIFT : IDLE;
            SHIFT:    next_state = (shift_cnt == 3) ? COUNTING : SHIFT;
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