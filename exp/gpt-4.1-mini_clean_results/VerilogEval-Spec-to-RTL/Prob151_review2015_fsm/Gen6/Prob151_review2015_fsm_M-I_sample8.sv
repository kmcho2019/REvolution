module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE     = 2'd0,
        SHIFTING = 2'd1,
        COUNTING = 2'd2,
        DONE     = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register to hold last 4 bits of serial data
    reg [3:0] shift_reg;

    // Counter for shift_ena cycles (0 to 3 for 4 cycles)
    reg [1:0] shift_cnt;
    wire shift_ena_wire = (state == SHIFTING);

    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: update shift_reg, shift_cnt, and state
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            shift_cnt <= 2'd0;
        end else begin
            // Shift in new data bit every clock cycle
            shift_reg <= {shift_reg[2:0], data};

            state <= next_state;

            // Update shift_cnt only in SHIFTING state
            if (state == SHIFTING) begin
                if (shift_cnt != 2'd3)
                    shift_cnt <= shift_cnt + 2'd1;
                else
                    shift_cnt <= 2'd0; // reset when done shifting
            end else begin
                shift_cnt <= 2'd0; // reset counter outside SHIFTING
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // If detected pattern, go to SHIFTING
                // Use shift_reg AFTER the new data shifted in (current value)
                if (shift_reg == PATTERN)
                    next_state = SHIFTING;
                else
                    next_state = IDLE;
            end
            SHIFTING: begin
                // Stay shifting for 4 cycles (counting shift_cnt)
                if (shift_cnt == 2'd3)
                    next_state = COUNTING;
                else
                    next_state = SHIFTING;
            end
            COUNTING: begin
                // Wait until done_counting asserted
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end
            DONE: begin
                // Wait for ack to return to IDLE and look for next pattern
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (state == SHIFTING);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule