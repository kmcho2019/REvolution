module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding as enum
    typedef enum reg [2:0] {
        A = 3'd0, // reset state, f=0, g=0
        B = 3'd1, // f=1 for one cycle after reset release
        C = 3'd2, // monitor x pattern (shift register)
        D = 3'd3, // g=1 for one cycle pulse after pattern detection
        E = 3'd4, // monitor y up to 2 cycles with g=1
        F = 3'd5, // g=1 permanent
        G = 3'd6  // g=0 permanent
    } state_t;

    state_t state, next_state;

    // Registered inputs to synchronize inputs and stabilize timing
    reg x_reg, y_reg;

    // Shift register for x pattern detection
    reg [2:0] x_shift;

    // Counter for monitoring y input in state E
    reg [1:0] y_count;

    // Sequential block: sample inputs, update state, registers, and outputs synchronously
    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous active low reset: reset all registers and outputs
            state   <= A;
            x_reg   <= 1'b0;
            y_reg   <= 1'b0;
            x_shift <= 3'b000;
            y_count <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            // Sample inputs synchronously
            x_reg <= x;
            y_reg <= y;

            // Update state
            state <= next_state;

            // Default outputs (will be overridden per state below)
            f <= 1'b0;
            g <= 1'b0;

            case (state)
                A: begin
                    // Hold outputs low, clear pattern and counters
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                B: begin
                    // f=1 pulse for one cycle immediately after reset release
                    f <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                C: begin
                    // Monitor x pattern: shift in x_reg
                    // Update x_shift to hold last 3 x inputs
                    x_shift <= {x_shift[1:0], x_reg};
                    y_count <= 2'd0;
                end

                D: begin
                    // g=1 pulse for one cycle after pattern detected
                    g <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                E: begin
                    // Hold g=1 while monitoring y for up to two cycles
                    g <= 1'b1;

                    // If y_reg=1 within two cycles, reset counter (transition logic decides)
                    // Otherwise increment y_count until max 2
                    if (y_reg == 1'b0 && y_count < 2'd2) begin
                        y_count <= y_count + 1'b1;
                    end
                    // If y_reg=1, y_count remains unchanged to trigger transition in next state logic
                end

                F: begin
                    // g=1 permanently until reset
                    g <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                G: begin
                    // g=0 permanently until reset
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                default: begin
                    // Safety default, treat as reset
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Next state combinational logic using registered inputs and registers (no delayed x_shift)
    always @(*) begin
        next_state = state; // Default hold

        case(state)
            A: begin
                // Wait in A while reset asserted; move to B on reset release
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // One clock cycle f=1 pulse done, move to pattern monitoring
                next_state = C;
            end

            C: begin
                // Detect pattern 101 in x_shift (last three sampled x values)
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // One clock g=1 pulse done, start monitoring y with g=1
                next_state = E;
            end

            E: begin
                // If y=1 detected within two cycles, move to F (g=1 permanent)
                if (y_reg == 1'b1)
                    next_state = F;
                // Else if y not detected after 2 cycles, move to G (g=0 permanent)
                else if (y_count >= 2'd2)
                    next_state = G;
                else
                    next_state = E;
            end

            F: begin
                // Hold g=1 permanent
                next_state = F;
            end

            G: begin
                // Hold g=0 permanent
                next_state = G;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule