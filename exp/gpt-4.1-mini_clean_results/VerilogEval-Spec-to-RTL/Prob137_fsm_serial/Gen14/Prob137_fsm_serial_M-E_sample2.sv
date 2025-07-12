module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // One-hot FSM states for each step in the frame reception
    typedef enum logic [9:0] {
        IDLE       = 10'b0000000001,
        START_BIT  = 10'b0000000010,
        BIT0       = 10'b0000000100,
        BIT1       = 10'b0000001000,
        BIT2       = 10'b0000010000,
        BIT3       = 10'b0000100000,
        BIT4       = 10'b0001000000,
        BIT5       = 10'b0010000000,
        BIT6       = 10'b0100000000,
        BIT7       = 10'b1000000000,
        STOP_OK    = 10'b0000000000, // We will use STOP_OK encoded separately for combinational done
        ERROR_WAIT = 10'b0000000000  // Use a separate reg for ERROR_WAIT state
    } state_t;

    // One-hot encoding cannot be fully expressed in SystemVerilog typedefs in all tools,
    // so declare states as parameters instead:
    localparam [9:0]
        IDLE       = 10'b0000000001,
        START_BIT  = 10'b0000000010,
        BIT0       = 10'b0000000100,
        BIT1       = 10'b0000001000,
        BIT2       = 10'b0000010000,
        BIT3       = 10'b0000100000,
        BIT4       = 10'b0001000000,
        BIT5       = 10'b0010000000,
        BIT6       = 10'b0100000000,
        BIT7       = 10'b1000000000;

    // ERROR_WAIT and STOP_OK states handled separately as flags/conditions

    reg [9:0] state, next_state;
    reg       error_wait;

    reg [7:0] shift_reg;

    // Next state logic
    always @(*) begin
        // Default stay
        next_state = state;
        if (error_wait) begin
            // Wait in error_wait until line goes back to idle (=1)
            if (in == 1'b1) begin
                next_state = IDLE;
            end
        end else begin
            case (state)
                IDLE: begin
                    // Wait for start bit == 0
                    if (in == 1'b0)
                        next_state = START_BIT;
                end

                START_BIT: begin
                    // Move to bit0 on next clock cycle regardless; start bit accepted
                    next_state = BIT0;
                end

                BIT0:   next_state = BIT1;
                BIT1:   next_state = BIT2;
                BIT2:   next_state = BIT3;
                BIT3:   next_state = BIT4;
                BIT4:   next_state = BIT5;
                BIT5:   next_state = BIT6;
                BIT6:   next_state = BIT7;
                BIT7:   begin
                    // After last data bit, move to stop bit checking (use IDLE or error_wait logic)
                    // But this FSM does not have explicit STOP state, handle stop bit by checking 'in' at next clock cycle
                    // Instead, use error_wait flag and done pulse logic below.
                    next_state = IDLE; // Tentative, actual stop bit handled in sequential block with error_wait
                end

                default: next_state = IDLE;
            endcase
        end
    end

    // Sequential logic for FSM state, shift register, error_wait flag
    // done pulse generated combinationally when valid stop bit detected immediately after BIT7
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            shift_reg  <= 8'b0;
            error_wait <= 1'b0;
            done_reg   <= 1'b0;
        end else begin
            done_reg <= 1'b0; // default done pulse clear

            if (error_wait) begin
                // Stay in error_wait until line idle = 1
                if (in == 1'b1) begin
                    error_wait <= 1'b0;
                    state      <= IDLE;
                end
            end else begin
                case (state)
                    IDLE: begin
                        if (in == 1'b0) begin
                            state     <= START_BIT;
                            shift_reg <= 8'b0;
                        end else begin
                            state <= IDLE;
                        end
                    end

                    START_BIT: begin
                        state <= BIT0;
                        // Shift in first data bit: put at MSB, shift right
                        shift_reg <= {in, shift_reg[7:1]};
                    end

                    BIT0, BIT1, BIT2, BIT3, BIT4, BIT5, BIT6: begin
                        // Shift in new bit each clock cycle
                        state <= next_state;
                        shift_reg <= {in, shift_reg[7:1]};
                    end

                    BIT7: begin
                        // Shift in last data bit
                        shift_reg <= {in, shift_reg[7:1]};
                        // Next clock check stop bit
                        if (in == 1'b0) begin
                            // Stop bit check next cycle: we must verify stop bit now
                            // Actually, stop bit is next bit 'in' at next clock cycle, so do not advance state
                            // Stay at BIT7 and use error_wait or done logic in next cycle
                            state <= BIT7; // Hold to check stop bit next cycle
                        end else begin
                            // The 'in' here is still data bit, stop bit comes after this
                            // But in this FSM implementation, treat that the stop bit comes after BIT7 state, handled below
                            state <= BIT7; // Hold one cycle
                        end
                    end

                    default: state <= IDLE;
                endcase

                // Check stop bit after BIT7 by looking at input 'in' next cycle when state==IDLE after BIT7
                // To implement this, keep track of last state

                // Instead, a better way: Use an extra reg 'check_stop' to handle stop bit sample
            end
        end
    end

    // To accurately check the stop bit, we add a small helper FSM with a flag that enables sampling
    // Let's add stop_bit_sample state:

    reg check_stop_bit;
    reg stop_bit_valid;

    always @(posedge clk) begin
        if (reset) begin
            check_stop_bit <= 1'b0;
            stop_bit_valid <= 1'b0;
        end else begin
            if (!error_wait) begin
                if (state == BIT7) begin
                    // After BIT7 state, next cycle sample stop bit from 'in'
                    check_stop_bit <= 1'b1;
                end else if (check_stop_bit) begin
                    // This cycle is stop bit sample
                    if (in == 1'b1) begin
                        stop_bit_valid <= 1'b1;
                        done_reg       <= 1'b1; // valid frame received
                        error_wait     <= 1'b0;
                    end else begin
                        stop_bit_valid <= 1'b0;
                        error_wait     <= 1'b1; // framing error, wait for idle
                    end
                    check_stop_bit <= 1'b0;

                    // Move FSM to IDLE after stop bit processed
                    state <= IDLE;
                end else begin
                    stop_bit_valid <= 1'b0;
                    // Normal operation, no stop bit checking
                end
            end else begin
                // error_wait state handled in FSM sequential block above
                check_stop_bit <= 1'b0;
                stop_bit_valid <= 1'b0;
            end
        end
    end

    assign done = done_reg;

endmodule