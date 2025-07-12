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

    reg [1:0] current_state, next_state;
    reg [3:0] pattern;
    reg [1:0] shift_counter;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Pattern detection (only in IDLE state)
    always @(posedge clk) begin
        if (reset || (current_state == DONE && next_state == IDLE)) begin
            pattern <= 4'b0;
        end else if (current_state == IDLE) begin
            pattern <= {pattern[2:0], data};
        end
    end

    // Shift counter (only in SHIFT state)
    always @(posedge clk) begin
        if (current_state != SHIFT) begin
            shift_counter <= 2'b0;
        end else begin
            shift_counter <= shift_counter + 1;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = (pattern == 4'b1101) ? SHIFT : IDLE;
            SHIFT: next_state = (shift_counter == 2'b11) ? COUNTING : SHIFT;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign shift_ena = (current_state == SHIFT);
    assign counting = (current_state == COUNTING);
    assign done = (current_state == DONE);

endmodule