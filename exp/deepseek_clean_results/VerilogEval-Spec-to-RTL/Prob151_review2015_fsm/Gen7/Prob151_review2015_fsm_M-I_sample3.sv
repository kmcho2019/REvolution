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
    localparam IDLE    = 2'b00;
    localparam SHIFT   = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset)
            pattern <= 4'b0;
        else if (state == IDLE)
            pattern <= {pattern[2:0], data};
        else if (state == SHIFT && shift_cnt == 0)
            pattern <= 4'b0; // Clear after detection
    end

    // Shift counter (0-3)
    always @(posedge clk) begin
        if (reset || state != SHIFT)
            shift_cnt <= 2'b0;
        else
            shift_cnt <= shift_cnt + 1;
    end

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (pattern == 4'b1101) ? SHIFT : IDLE;
            SHIFT: next_state = (shift_cnt == 2'b11) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule