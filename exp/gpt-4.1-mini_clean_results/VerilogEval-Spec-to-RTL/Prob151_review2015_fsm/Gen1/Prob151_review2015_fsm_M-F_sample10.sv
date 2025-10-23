module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;       // Sliding 4-bit shift register for pattern detection
    reg [2:0] shift_counter;   // Counts shift_ena cycles (0 to 3)

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_counter <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs off, set below
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Shift in data continuously for pattern detection
                    shift_reg <= {shift_reg[2:0], data};
                end

                SHIFT: begin
                    // Assert shift_ena and count 4 cycles
                    shift_ena <= 1'b1;
                    shift_counter <= shift_counter + 3'd1;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    // During counting, no shift_reg update needed
                end

                DONE: begin
                    done <= 1'b1;
                    // Wait for ack, no shift_reg update needed
                end
            endcase

            // Manage shift_counter reset in IDLE and other states
            if (state != SHIFT)
                shift_counter <= 3'd0;
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end

            SHIFT: begin
                // After 4 asserted cycles of shift_ena (count 0 to 3)
                if (shift_counter == 3'd3)
                    next_state = COUNTING;
            end

            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

endmodule