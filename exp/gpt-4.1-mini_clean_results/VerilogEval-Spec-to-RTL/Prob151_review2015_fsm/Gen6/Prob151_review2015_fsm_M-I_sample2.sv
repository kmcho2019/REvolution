module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // FSM states encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t state, next_state;

    // 4-bit shift register for pattern detection
    reg [3:0] pattern_shift;

    wire pattern_match = (pattern_shift == 4'b1101);

    // 2-bit counter for 4 SHIFT cycles
    reg [1:0] shift_count;

    // Sequential logic for pattern shift register and state transition
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'd0;
            state         <= IDLE;
            shift_count   <= 2'd0;
        end else begin
            // Shift data in every clock cycle (regardless of FSM state)
            pattern_shift <= {pattern_shift[2:0], data};

            state <= next_state;

            // Shift count increments only in SHIFT state; reset otherwise
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                // On detecting pattern 1101 in IDLE, move to SHIFT
                if (pattern_match)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                // After 4 shift cycles (counts 0 to 3), move to COUNT
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                // Wait until done_counting is high
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                // Wait until ack is high to return to IDLE
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Outputs synchronous with state
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            shift_ena <= (state == SHIFT);
            counting  <= (state == COUNT);
            done      <= (state == DONE);
        end
    end

endmodule