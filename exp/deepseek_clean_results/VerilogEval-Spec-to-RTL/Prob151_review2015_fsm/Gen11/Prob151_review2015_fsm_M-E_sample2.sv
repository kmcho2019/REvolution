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

    // Enhanced state encoding
    localparam IDLE      = 3'b000;
    localparam VALIDATE  = 3'b001;
    localparam SHIFT     = 3'b010;
    localparam COUNT     = 3'b011;
    localparam NOTIFY    = 3'b100;

    reg [2:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [2:0] shift_counter;

    // Pattern detection register (cleared when leaving IDLE)
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state != IDLE) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Shift counter (counts 0-7)
    always @(posedge clk) begin
        if (reset || state != SHIFT) begin
            shift_counter <= 3'b0;
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
            IDLE:     next_state = (pattern_reg == 4'b1101) ? VALIDATE : IDLE;
            VALIDATE: next_state = SHIFT;  // Single-cycle validation
            SHIFT:    next_state = (shift_counter == 3'd3) ? COUNT : SHIFT;
            COUNT:    next_state = done_counting ? NOTIFY : COUNT;
            NOTIFY:   next_state = ack ? IDLE : NOTIFY;
            default:  next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (state == SHIFT) && (shift_counter < 3'd4);
    assign counting  = (state == COUNT);
    assign done      = (state == NOTIFY);

endmodule