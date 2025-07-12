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
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // Continuous pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0;
        end else begin
            pattern <= {pattern[2:0], data};
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

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                if (shift_cnt == 2'b11) begin  // After 4 cycles (0-3)
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

endmodule