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

    // Optimized state encoding
    localparam IDLE    = 2'b00;
    localparam SHIFT   = 2'b01;
    localparam COUNT   = 2'b10;
    localparam NOTIFY  = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_counter;

    // Pattern detection register
    always @(posedge clk) begin
        if (reset || state != IDLE) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Shift counter (counts 0-3)
    always @(posedge clk) begin
        if (reset || state != SHIFT) begin
            shift_counter <= 2'b0;
        end else begin
            shift_counter <= shift_counter + 1'b1;
        end
    end

    // State transition logic
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
            IDLE:   next_state = (pattern_reg == 4'b1101) ? SHIFT : IDLE;
            SHIFT:  next_state = (shift_counter == 2'd3) ? COUNT : SHIFT;
            COUNT:  next_state = done_counting ? NOTIFY : COUNT;
            NOTIFY: next_state = ack ? IDLE : NOTIFY;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == NOTIFY);

endmodule