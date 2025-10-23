module TopModule (
    input        clk,
    input        reset,
    input        data,
    input        done_counting,
    input        ack,
    output reg   shift_ena,
    output reg   counting,
    output reg   done
);
    // FSM states definition
    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        SHIFT  = 2'b01,
        COUNT  = 2'b10,
        DONE   = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;      // 4-bit shift register for pattern detection
    reg [2:0] shift_cnt;      // counts 0 to 3 for 4 cycles during SHIFT state

    // Sequential logic: shift register and FSM state updates
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0000;
            shift_cnt <= 3'd0;
        end else begin
            // Always shift in the serial data every clock cycle
            shift_reg <= {shift_reg[2:0], data};

            state <= next_state;

            if (state == SHIFT)
                shift_cnt <= shift_cnt + 3'd1;
            else
                shift_cnt <= 3'd0;
        end
    end

    // Combinational logic: next state and outputs
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;
        next_state = state;

        case (state)
            SEARCH: begin
                // Detect pattern 1101 continuously
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end

            SHIFT: begin
                shift_ena = 1'b1;
                // After 4 cycles (shift_cnt counts 0..3)
                if (shift_cnt == 3'd3)
                    next_state = COUNT;
            end

            COUNT: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                done = 1'b1;
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule