module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // States - one-hot style encoding for clarity
    typedef enum reg [2:0] {
        IDLE     = 3'b001,
        SHIFT    = 3'b010,
        COUNTING = 3'b100,
        DONE     = 3'b000 // Not used as one-hot but used for clarity (will assign proper code below)
    } state_t;

    // We'll define encoding with 2 bits instead for simplicity, as done before:
    localparam IDLE     = 2'd0;
    localparam SHIFT    = 2'd1;
    localparam COUNTING = 2'd2;
    localparam DONE     = 2'd3;

    reg [1:0] state, next_state;

    // 4-bit shift register for pattern detection
    reg [3:0] shift_reg;

    // Detect pattern 1101
    wire pattern_detected = (shift_reg == 4'b1101);

    // SHIFT cycle counter (2 bits for counts 0..3)
    reg [1:0] shift_count;

    // Shift register update, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // FSM sequential: state and shift_count updates
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // FSM combinational next-state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                // Transition to SHIFT on pattern_detected
                if (pattern_detected)
                    next_state = SHIFT;
            end

            SHIFT: begin
                // After shifting 4 bits, move to COUNTING
                if (shift_count == 2'd3)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Wait for done_counting signal
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack signal to return to IDLE
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Moore outputs depend only on state
    always @(*) begin
        // Default outputs low
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            SHIFT:    shift_ena = 1'b1;
            COUNTING: counting  = 1'b1;
            DONE:     done      = 1'b1;
        endcase
    end

endmodule