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

    // Optimized state encoding (one-hot for reliability)
    typedef enum logic [4:0] {
        SEARCH = 5'b00001,
        VERIFY = 5'b00010,
        SHIFT  = 5'b00100,
        WAIT   = 5'b01000,
        ALERT  = 5'b10000
    } state_t;

    state_t current_state, next_state;

    // Pattern matching registers
    reg [2:0] pattern_ptr;
    reg [3:0] expected_pattern = 4'b1101;

    // Shift cycle counter
    reg [2:0] shift_cycles;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= SEARCH;
            pattern_ptr <= 3'b0;
            shift_cycles <= 3'b0;
        end else begin
            current_state <= next_state;

            // Pattern pointer management
            if (current_state == SEARCH) begin
                pattern_ptr <= (data == expected_pattern[pattern_ptr]) ? 
                              pattern_ptr + 1 : 3'b0;
            end

            // Shift cycle counter
            if (current_state == SHIFT) begin
                shift_cycles <= shift_cycles + 1;
            end else begin
                shift_cycles <= 3'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            SEARCH: 
                next_state = (pattern_ptr == 3'd3) ? VERIFY : SEARCH;

            VERIFY:
                next_state = (data == expected_pattern[3]) ? SHIFT : SEARCH;

            SHIFT:
                next_state = (shift_cycles == 3'd3) ? WAIT : SHIFT;

            WAIT:
                next_state = done_counting ? ALERT : WAIT;

            ALERT:
                next_state = ack ? SEARCH : ALERT;

            default:
                next_state = SEARCH;
        endcase
    end

    // Output generation with registered outputs
    reg shift_ena_reg, counting_reg, done_reg;
    always @(posedge clk) begin
        if (reset) begin
            shift_ena_reg <= 1'b0;
            counting_reg <= 1'b0;
            done_reg <= 1'b0;
        end else begin
            shift_ena_reg <= (current_state == SHIFT);
            counting_reg <= (current_state == WAIT);
            done_reg <= (current_state == ALERT);
        end
    end

    assign shift_ena = shift_ena_reg;
    assign counting = counting_reg;
    assign done = done_reg;

endmodule