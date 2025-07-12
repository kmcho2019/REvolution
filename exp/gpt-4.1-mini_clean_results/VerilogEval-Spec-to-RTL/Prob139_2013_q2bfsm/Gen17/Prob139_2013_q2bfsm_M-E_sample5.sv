module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding using localparams for clarity
    localparam [2:0]
        STATE_A      = 3'd0,  // Reset state, f=0,g=0
        STATE_B      = 3'd1,  // f=1 for one clock cycle (pulse after reset release)
        STATE_C      = 3'd2,  // Monitor x input for pattern 1-0-1
        STATE_D      = 3'd3,  // g=1 for one clock cycle (pulse after pattern detected)
        STATE_E      = 3'd4,  // Monitor y input for up to 2 cycles with g=1
        STATE_F      = 3'd5,  // Permanent g=1 (y detected)
        STATE_G      = 3'd6;  // Permanent g=0 (y not detected in time)

    reg [2:0] state, next_state;

    reg [2:0] x_shift;      // 3-bit shift register to hold last 3 x samples
    reg [1:0] y_timer;      // counts how many cycles have passed monitoring y (max 2)

    // Sequential logic: state and registers update on clock edge with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state    <= STATE_A;
            x_shift  <= 3'b000;
            y_timer  <= 2'd0;
        end else begin
            state <= next_state;
            
            // Update x_shift only in STATE_C; hold otherwise
            if (state == STATE_C) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000; // Clear when not monitoring x pattern
            end

            // Update y_timer only in STATE_E; reset otherwise
            if (state == STATE_E) begin
                y_timer <= y_timer + 1'b1;
            end else begin
                y_timer <= 2'd0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold

        case (state)
            STATE_A: begin
                // Wait here while resetn low
                if (resetn)
                    next_state = STATE_B;
            end

            STATE_B: begin
                // f=1 pulse done, move to monitor x pattern
                next_state = STATE_C;
            end

            STATE_C: begin
                // Wait until we've collected at least 3 samples (x_shift valid)
                // Pattern to detect is 1-0-1, x_shift[2] oldest, x_shift[0] newest
                // So pattern is x_shift == 3'b101
                if (x_shift == 3'b101)
                    next_state = STATE_D;
                else
                    next_state = STATE_C;
            end

            STATE_D: begin
                // One cycle g=1 pulse done, now monitor y input
                next_state = STATE_E;
            end

            STATE_E: begin
                // If y==1 detected within 2 cycles, go permanent g=1
                if (y == 1'b1)
                    next_state = STATE_F;
                // If 2 cycles elapsed without y=1, go permanent g=0
                else if (y_timer == 2'd2)
                    next_state = STATE_G;
                else
                    next_state = STATE_E;
            end

            STATE_F: begin
                // Hold g=1 permanently until reset
                next_state = STATE_F;
            end

            STATE_G: begin
                // Hold g=0 permanently until reset
                next_state = STATE_G;
            end

            default: next_state = STATE_A;
        endcase
    end

    // Outputs combinational based on state (Moore FSM)
    always @(*) begin
        f = 1'b0;
        g = 1'b0;

        case (state)
            STATE_B: f = 1'b1;
            STATE_D: g = 1'b1;
            STATE_E: g = 1'b1;
            STATE_F: g = 1'b1;
            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule