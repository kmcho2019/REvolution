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
    localparam NOTIFY  = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_counter;

    // Pattern detection register - only updated in IDLE state
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end else begin
            pattern_reg <= 4'b0;
        end
    end

    // Shift counter - counts 0-3 during SHIFT state
    always @(posedge clk) begin
        if (reset) begin
            shift_counter <= 2'b0;
        end else if (state == SHIFT) begin
            shift_counter <= shift_counter + 1'b1;
        end else begin
            shift_counter <= 2'b0;
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

    // Output logic - registered for clean timing
    reg shift_ena_reg, counting_reg, done_reg;
    always @(posedge clk) begin
        if (reset) begin
            shift_ena_reg <= 1'b0;
            counting_reg <= 1'b0;
            done_reg <= 1'b0;
        end else begin
            shift_ena_reg <= (state == SHIFT);
            counting_reg <= (state == COUNT);
            done_reg <= (state == NOTIFY);
        end
    end

    assign shift_ena = shift_ena_reg;
    assign counting = counting_reg;
    assign done = done_reg;

endmodule