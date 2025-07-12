module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // State encoding
    typedef enum logic [2:0] {
        SEARCH = 3'd0,
        SHIFT  = 3'd1,
        COUNT  = 3'd2,
        DONE   = 3'd3
    } state_t;

    state_t state, next_state;

    // Pattern match register to track how many bits matched of "1101"
    // We will update it every cycle in SEARCH state
    reg [1:0] shift_count; // counts 0 to 3 for shift cycles
    reg [3:0] pattern_reg; // shift register for pattern detection bits

    // On every clock, shift in data to pattern_reg (only when in SEARCH)
    // But we can implement pattern detection by updating pattern_reg regardless and use it in SEARCH state

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_count <= 2'd0;
            pattern_reg <= 4'd0;
        end else begin
            state <= next_state;

            if (state == SEARCH) begin
                pattern_reg <= {pattern_reg[2:0], data};
            end

            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_reg == 4'b1101) // pattern detected
                    next_state = SHIFT;
            end

            SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = COUNT;
            end

            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Outputs (Moore machine)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule