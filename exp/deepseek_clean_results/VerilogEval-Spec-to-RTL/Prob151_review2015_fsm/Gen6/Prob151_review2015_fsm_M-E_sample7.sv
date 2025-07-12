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
    typedef enum logic [1:0] {
        IDLE,
        SHIFT,
        COUNT,
        DONE
    } state_t;

    state_t current_state, next_state;
    reg [3:0] shift_reg;
    reg [1:0] shift_count;
    wire pattern_match;

    // Continuous shift register
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // Pattern detection (combinatorial)
    assign pattern_match = (shift_reg == 4'b1101);

    // Shift counter
    always @(posedge clk) begin
        if (reset || current_state != SHIFT) begin
            shift_count <= 2'b0;
        end else begin
            shift_count <= shift_count + 1;
        end
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: if (pattern_match) next_state = SHIFT;
            SHIFT: if (shift_count == 2'b11) next_state = COUNT;
            COUNT: if (done_counting) next_state = DONE;
            DONE: if (ack) next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (current_state == SHIFT);
    assign counting = (current_state == COUNT);
    assign done = (current_state == DONE);

endmodule