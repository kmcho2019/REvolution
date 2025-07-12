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

    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;

    state_t state, next_state;
    reg [3:0] shift_reg;      // holds last 4 bits shifted in
    reg [1:0] shift_count;    // counts 0 to 3 during SHIFT

    // Combinational logic for next state based on current state and inputs
    always @(*) begin
        // Default to hold state
        next_state = state;
        case (state)
            IDLE: begin
                // Check if after shifting in data, pattern 1101 is detected
                // Since shift_reg will be updated next clock, compute next shift_reg for detection
                // Actually, shift_reg will be updated on clock edge with {shift_reg[2:0], data}
                // So, to detect pattern on next cycle, we check pattern on next shift_reg value:
                // Use temporary variable for next shift_reg
                // But combinational always cannot access regs at posedge clk
                // Instead, replicate logic here:
                if ({shift_reg[2:0], data} == 4'b1101)
                    next_state = SHIFT;
            end

            SHIFT: begin
                if (shift_count == 2'd3)
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

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: update state, shift_reg, shift_count, and outputs
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            shift_reg   <= 4'd0;
            shift_count <= 2'd0;
            shift_ena   <= 1'b0;
            counting    <= 1'b0;
            done        <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in data every cycle regardless of state
            shift_reg <= {shift_reg[2:0], data};

            // Manage shift_count counter in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 2'd0;
            end

            // Outputs depend only on registered state (Moore outputs)
            shift_ena <= (next_state == SHIFT) || (state == SHIFT); 
            counting  <= (next_state == COUNTING) || (state == COUNTING);
            done      <= (next_state == DONE) || (state == DONE);
            // Using (next_state == X) || (state == X) ensures outputs are asserted full clock cycles after transitions
            // But if strict Moore outputs desired, could use only 'state == X'
            // Here, asserting outputs throughout the whole state duration, including transition cycle
        end
    end

endmodule