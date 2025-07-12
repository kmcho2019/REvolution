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
    reg [3:0] pattern_reg;
    reg [1:0] shift_counter;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern_reg == 4'b1101) ? SHIFT : IDLE;
            SHIFT: next_state = (shift_counter == 2'b00) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // State registers and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            state <= next_state;

            // Pattern detection in IDLE state
            if (state == IDLE) begin
                pattern_reg <= {pattern_reg[2:0], data};
            end

            // Shift counter control
            if (state == SHIFT) begin
                if (shift_counter > 0)
                    shift_counter <= shift_counter - 1'b1;
                else
                    shift_counter <= 2'b11; // Initialize counter when entering SHIFT
            end else begin
                shift_counter <= 2'b11; // Maintain counter value outside SHIFT
            end
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule