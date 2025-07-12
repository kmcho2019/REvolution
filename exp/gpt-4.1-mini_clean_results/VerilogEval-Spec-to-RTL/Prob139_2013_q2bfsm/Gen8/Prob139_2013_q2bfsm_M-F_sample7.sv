module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // One-hot state encoding
    typedef enum logic [2:0] {
        A = 3'b000, // reset active
        B = 3'b001, // f=1 for one cycle after reset
        C = 3'b010, // monitor x pattern 1-0-1 with shift register
        D = 3'b011, // output g=1 for one cycle (immediately after pattern detected)
        E = 3'b100, // monitor y for up to two cycles, keep g=1 permanently if y=1 within 2 cycles
        F = 3'b101  // permanent g=0 after timeout until reset
    } state_t;

    state_t state, next_state;

    logic [2:0] x_shift;       // Shift register to detect pattern 1-0-1 on x
    logic [1:0] y_counter;     // Counts up to 1 (for two cycles monitoring y in E)

    // Synchronous logic: state, shift register, counters, and outputs
    always_ff @(posedge clk) begin
        if (!resetn) begin
            state    <= A;
            x_shift  <= 3'b000;
            y_counter<= 2'd0;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            // Update x shift register every cycle except in reset state A
            // In reset (state A), x_shift cleared to zero
            if (state != A)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            // State update
            state <= next_state;

            // y_counter: valid only in state E; reset otherwise
            if (next_state == E) begin
                if (state == E)
                    y_counter <= y_counter + 1'b1;
                else
                    y_counter <= 2'd0; // entering E resets counter
            end else
                y_counter <= 2'd0;

            // Outputs f and g driven based on next state (registered output aligned to state transitions)
            // f=1 only in B
            // g=1 in D and E
            f <= (next_state == B) ? 1'b1 : 1'b0;
            g <= (next_state == D || next_state == E) ? 1'b1 : 1'b0;
        end
    end

    // Next state combinational logic
    always_comb begin
        next_state = state;

        case (state)
            A: begin
                if (resetn)
                    next_state = B; // after reset deasserted, move to B
                else
                    next_state = A; // stay in reset
            end

            B: begin
                // One cycle with f=1, then start monitoring x pattern
                next_state = C;
            end

            C: begin
                // Wait here until x_shift matches pattern 1-0-1
                // Note: x_shift[2:0] = {x(t-2), x(t-1), x(t)}
                if (x_shift == 3'b101)
                    next_state = D; // pattern detected, next cycle set g=1
                else
                    next_state = C; // keep monitoring
            end

            D: begin
                // g=1 one cycle
                // Then start monitoring y for up to 2 cycles in E
                next_state = E;
            end

            E: begin
                if (y == 1'b1) begin
                    // y detected within at most two clock cycles, stay here permanently
                    next_state = E;
                end else if (y_counter == 2'd1) begin
                    // y not detected within two cycles (counting 0 and 1 = two clocks)
                    next_state = F;
                end else begin
                    // keep waiting in E up to 2 cycles
                    next_state = E;
                end
            end

            F: begin
                // Permanent g=0 until reset
                next_state = F;
            end

            default: next_state = A;
        endcase
    end

endmodule