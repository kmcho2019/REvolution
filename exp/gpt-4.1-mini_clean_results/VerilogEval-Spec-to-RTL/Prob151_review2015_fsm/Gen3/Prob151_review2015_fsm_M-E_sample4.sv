module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // State encoding
    localparam WAIT_FOR_PATTERN = 2'd0;
    localparam SHIFT_BITS       = 2'd1;
    localparam WAIT_COUNT       = 2'd2;
    localparam WAIT_ACK         = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] shift_reg;        // shift register for pattern detection
    reg [2:0] shift_counter;    // counts 0 to 3 during SHIFT_BITS (4 cycles)

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            WAIT_FOR_PATTERN: begin
                // If pattern detected, go to SHIFT_BITS
                if (shift_reg == 4'b1101)
                    next_state = SHIFT_BITS;
            end
            SHIFT_BITS: begin
                if (shift_counter == 3'd3)  // completed 4 shifts
                    next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                if (done_counting)
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = WAIT_FOR_PATTERN;
            end
            default: next_state = WAIT_FOR_PATTERN;
        endcase
    end

    // Sequential logic: state update, shift_reg update, counters, and outputs
    always @(posedge clk) begin
        if (reset) begin
            state         <= WAIT_FOR_PATTERN;
            shift_reg     <= 4'b0000;
            shift_counter <= 3'd0;
            shift_ena     <= 1'b0;
            counting      <= 1'b0;
            done          <= 1'b0;
        end else begin
            state <= next_state;

            // Shift data every clock in WAIT_FOR_PATTERN and SHIFT_BITS states for pattern tracking
            // In WAIT_FOR_PATTERN, shift_reg tracks last 4 bits to detect pattern
            // In SHIFT_BITS, continue shifting to fill delay bits (not used here but realistic)
            if (state == WAIT_FOR_PATTERN || state == SHIFT_BITS) begin
                shift_reg <= {shift_reg[2:0], data};
            end

            // shift_counter counts 4 cycles only in SHIFT_BITS
            if (state == SHIFT_BITS) begin
                shift_counter <= shift_counter + 1'b1;
            end else begin
                shift_counter <= 3'd0;
            end

            // Outputs (Moore): asserted only based on current state
            shift_ena <= (state == SHIFT_BITS);
            counting  <= (state == WAIT_COUNT);
            done      <= (state == WAIT_ACK);
        end
    end

endmodule