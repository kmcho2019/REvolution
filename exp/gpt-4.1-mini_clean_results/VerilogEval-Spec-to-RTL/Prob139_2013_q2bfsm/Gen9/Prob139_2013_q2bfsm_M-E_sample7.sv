module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        S_A    = 3'd0,  // Reset active
        S_B    = 3'd1,  // f=1 pulse after reset deasserted (one cycle)
        S_C    = 3'd2,  // Monitor x pattern 1,0,1
        S_D    = 3'd3,  // g=1 one cycle (immediately after pattern detected)
        S_E    = 3'd4,  // Monitor y for up to two cycles, g=1 maintained
        S_F    = 3'd5,  // Permanent g=1 state (if y=1 detected within two cycles)
        S_G    = 3'd6   // Permanent g=0 state (if y=1 not detected within two cycles)
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;       // 3-bit shift register for x samples
    reg [1:0] y_monitor_cnt; // Counts 0,1 for y monitoring cycles in S_E

    // Sequential logic: state, shift register, counter, outputs
    always @(posedge clk) begin
        if (!resetn) begin
            state       <= S_A;
            x_shift     <= 3'b000;
            y_monitor_cnt <= 2'd0;
            f           <= 1'b0;
            g           <= 1'b0;
        end else begin
            state <= next_state;

            // Update x_shift register in all states except reset
            if (state != S_A) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000;
            end

            // Update y_monitor_cnt only in S_E
            if (state == S_E) begin
                if (next_state == S_E)
                    y_monitor_cnt <= y_monitor_cnt + 1'b1;
                else
                    y_monitor_cnt <= 2'd0; // reset counter on leaving S_E
            end else begin
                y_monitor_cnt <= 2'd0;
            end

            // Outputs assigned based on current state (Moore outputs)
            f <= (state == S_B);
            g <= (state == S_D) || (state == S_E) || (state == S_F);
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            S_A: begin
                if (resetn)
                    next_state = S_B; // move out of reset
                else
                    next_state = S_A;
            end

            S_B: begin
                // f=1 for exactly one cycle, then start pattern monitoring
                next_state = S_C;
            end

            S_C: begin
                // Wait for pattern 1,0,1 in consecutive cycles on x
                // x_shift newest bit is rightmost: x_shift = {x(t-2), x(t-1), x(t)}
                if (x_shift == 3'b101)
                    next_state = S_D; // pattern detected
                else
                    next_state = S_C;
            end

            S_D: begin
                // g=1 for one cycle (immediately after pattern detected)
                // Then monitor y input for at most two cycles
                next_state = S_E;
            end

            S_E: begin
                // Maintain g=1 while monitoring y for up to two cycles
                if (y == 1'b1) begin
                    next_state = S_F; // y=1 detected, permanent g=1 state
                end else if (y_monitor_cnt == 2'd1) begin
                    // Two clock cycles elapsed without y=1
                    next_state = S_G; // permanent g=0 state
                end else begin
                    next_state = S_E; // keep monitoring
                end
            end

            S_F: begin
                // Permanent g=1 until reset
                next_state = S_F;
            end

            S_G: begin
                // Permanent g=0 until reset
                next_state = S_G;
            end

            default: next_state = S_A;
        endcase
    end

endmodule