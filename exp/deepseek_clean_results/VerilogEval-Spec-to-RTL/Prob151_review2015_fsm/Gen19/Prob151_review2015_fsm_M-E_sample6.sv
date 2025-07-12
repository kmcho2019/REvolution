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
    localparam IDLE      = 3'b000;
    localparam PRE_SHIFT = 3'b001;
    localparam SHIFT     = 3'b010;
    localparam COUNT     = 3'b011;
    localparam DONE      = 3'b100;

    reg [2:0] state, next_state;
    reg [3:0] shift_reg;
    reg [1:0] shift_counter;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Shift register and pattern storage
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else if (state == IDLE || state == SHIFT) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // Shift cycle counter
    always @(posedge clk) begin
        if (reset || state != SHIFT) begin
            shift_counter <= 2'b0;
        end else begin
            shift_counter <= shift_counter + 1'b1;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:      next_state = (shift_reg == 4'b1101) ? PRE_SHIFT : IDLE;
            PRE_SHIFT: next_state = SHIFT;
            SHIFT:     next_state = (shift_counter == 2'b11) ? COUNT : SHIFT;
            COUNT:     next_state = done_counting ? DONE : COUNT;
            DONE:      next_state = ack ? IDLE : DONE;
            default:   next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule