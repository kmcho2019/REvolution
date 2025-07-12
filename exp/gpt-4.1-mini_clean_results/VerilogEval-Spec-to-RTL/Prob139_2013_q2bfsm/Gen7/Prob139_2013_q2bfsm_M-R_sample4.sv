module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // One-hot state encoding as logic signals for clarity
    logic state_A, state_B, state_C, state_D, state_E, state_F;

    // State register signals
    logic next_state_A, next_state_B, next_state_C, next_state_D, next_state_E, next_state_F;

    // Shift register for pattern detection of '1-0-1' on x
    logic [2:0] x_shift;

    // Counter for y monitoring in state D (0..2)
    logic [1:0] y_counter;

    // Synchronous state and counters update
    always_ff @(posedge clk) begin
        if (!resetn) begin
            // Reset all states and counters
            state_A <= 1'b1;
            state_B <= 1'b0;
            state_C <= 1'b0;
            state_D <= 1'b0;
            state_E <= 1'b0;
            state_F <= 1'b0;

            x_shift <= 3'b000;
            y_counter <= 2'd0;
        end else begin
            // Update states
            state_A <= next_state_A;
            state_B <= next_state_B;
            state_C <= next_state_C;
            state_D <= next_state_D;
            state_E <= next_state_E;
            state_F <= next_state_F;

            // Shift x input to detect pattern in C and D states; reset otherwise
            if (state_C) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000;
            end

            // Update y_counter only in state D
            if (state_D) begin
                y_counter <= y_counter + 1'b1;
            end else begin
                y_counter <= 2'd0;
            end
        end
    end

    // Next state logic combinational
    always_comb begin
        // Default next states to current states (hold)
        next_state_A = state_A;
        next_state_B = state_B;
        next_state_C = state_C;
        next_state_D = state_D;
        next_state_E = state_E;
        next_state_F = state_F;

        if (!resetn) begin
            // On reset asserted, force state A
            next_state_A = 1'b1;
            next_state_B = 1'b0;
            next_state_C = 1'b0;
            next_state_D = 1'b0;
            next_state_E = 1'b0;
            next_state_F = 1'b0;
        end else begin
            if (state_A) begin
                // Move to B after reset deasserted
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end else if (state_B) begin
                // After one cycle with f=1, go to pattern detection
                next_state_B = 1'b0;
                next_state_C = 1'b1;
            end else if (state_C) begin
                // Detect pattern 1-0-1 on x_shift
                // x_shift contains last three samples of x with MSB oldest: {x(t-2),x(t-1),x(t)}
                // We want pattern '1','0','1'
                if (x_shift == 3'b101) begin
                    next_state_C = 1'b0;
                    next_state_D = 1'b1;
                end else begin
                    // Remain in C waiting for pattern
                    next_state_C = 1'b1;
                end
            end else if (state_D) begin
                // Monitor y for up to two cycles
                if (y == 1'b1) begin
                    // y detected within 2 cycles, move to permanent g=1 state
                    next_state_D = 1'b0;
                    next_state_E = 1'b1;
                end else if (y_counter == 2'd2) begin
                    // y not detected within 2 cycles, go to permanent g=0 state
                    next_state_D = 1'b0;
                    next_state_F = 1'b1;
                end else begin
                    // Stay in D monitoring y
                    next_state_D = 1'b1;
                end
            end else if (state_E) begin
                // Hold permanent g=1 state until reset
                next_state_E = 1'b1;
            end else if (state_F) begin
                // Hold permanent g=0 state until reset
                next_state_F = 1'b1;
            end else begin
                // Should never reach here, default to A
                next_state_A = 1'b1;
            end
        end
    end

    // Output logic (Moore outputs) driven by states
    always_comb begin
        f = 1'b0;
        g = 1'b0;
        if (state_B)
            f = 1'b1;     // f=1 one clock cycle after reset release
        if (state_D || state_E)
            g = 1'b1;     // g=1 while monitoring y and permanently after y=1 detected
        // g=0 in all other states (including reset and permanent g=0 state_F)
    end

endmodule