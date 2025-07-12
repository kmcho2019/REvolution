module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State definitions
    typedef enum logic [2:0] {
        STATE_A = 3'd0, // Reset state, f=0, g=0
        STATE_B = 3'd1, // f=1 pulse (1 cycle)
        STATE_C = 3'd2, // Monitor x input rolling pattern 1-0-1
        STATE_D = 3'd3, // g=1 pulse (1 cycle)
        STATE_E = 3'd4, // Monitor y up to 2 cycles, g=1 held
        STATE_F = 3'd5, // Permanent g=1
        STATE_G = 3'd6  // Permanent g=0
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;      // Shift register for last 3 x samples
    reg [1:0] y_count;      // Counter for y monitoring in STATE_E

    // Sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= STATE_A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_shift only in STATE_C, otherwise hold/reset
            if (next_state == STATE_C) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000;
            end

            // Update y_count only in STATE_E, else reset
            if (next_state == STATE_E) begin
                // Increment y_count each cycle in STATE_E
                if (state == STATE_E)
                    y_count <= y_count + 1'b1;
                else
                    y_count <= 2'd0; // reset on entering STATE_E
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            STATE_A: begin
                // Wait for reset release
                if (resetn)
                    next_state = STATE_B;
            end

            STATE_B: begin
                // One cycle f pulse done, go monitor x pattern
                next_state = STATE_C;
            end

            STATE_C: begin
                // Continuously monitor x_shift for pattern 1-0-1
                // x_shift = {oldest, mid, newest} bits
                // Check if last 3 samples equal 3'b101
                if (x_shift == 3'b101)
                    next_state = STATE_D;
                else
                    next_state = STATE_C; // stay here
            end

            STATE_D: begin
                // One cycle g pulse done, start monitoring y
                next_state = STATE_E;
            end

            STATE_E: begin
                // Hold g=1, watch y up to 2 cycles max
                if (y == 1'b1)
                    next_state = STATE_F; // permanent g=1
                else if (y_count == 2'd2)
                    next_state = STATE_G; // permanent g=0
                else
                    next_state = STATE_E; // keep monitoring
            end

            STATE_F: begin
                // Permanent g=1 state until reset
                if (!resetn)
                    next_state = STATE_A;
                else
                    next_state = STATE_F;
            end

            STATE_G: begin
                // Permanent g=0 state until reset
                if (!resetn)
                    next_state = STATE_A;
                else
                    next_state = STATE_G;
            end

            default: next_state = STATE_A;
        endcase
    end

    // Output logic (Moore style, except f and g are based on state only)
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;

        case (state)
            STATE_B: f = 1'b1;    // f pulse one cycle after reset release
            STATE_D: g = 1'b1;    // g pulse one cycle after pattern detection
            STATE_E: g = 1'b1;    // hold g=1 while monitoring y
            STATE_F: g = 1'b1;    // permanent g=1 after y detected
            // g=0 in other states by default
        endcase
    end

endmodule