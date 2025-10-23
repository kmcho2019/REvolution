module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    localparam A           = 4'd0; // reset state
    localparam F_ONE       = 4'd1; // f=1 for one cycle after reset
    localparam WAIT_X1     = 4'd2; // waiting for x=1
    localparam WAIT_X0     = 4'd3; // waiting for x=0 after x=1
    localparam WAIT_X2     = 4'd4; // waiting for x=1 to complete pattern 1,0,1
    localparam G_ON_0      = 4'd5; // g=1 first cycle, monitor y
    localparam G_ON_1      = 4'd6; // g=1 second cycle, monitor y
    localparam G_ON_PERM   = 4'd7; // g=1 permanently
    localparam G_OFF_PERM  = 4'd8; // g=0 permanently

    reg [3:0] state, next_state;
    reg reset_released; // Flag to detect rising edge of reset de-assertion

    // Sequential block: state and outputs update on rising clock edge with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
            reset_released <= 1'b0;
        end else begin
            // Detect rising edge of resetn: reset just released this cycle
            reset_released <= (~reset_released) | 1'b0; // hold for one cycle after resetn goes high
            if (~reset_released && resetn)
                reset_released <= 1'b1;

            state <= next_state;

            // Output logic synchronous to state
            case (state)
                A: begin
                    // During reset (state A), outputs low
                    // After reset released, f=1 for one cycle (state F_ONE)
                    f <= 1'b0;
                    g <= 1'b0;
                end

                F_ONE: begin
                    // f asserted one cycle
                    f <= 1'b1;
                    g <= 1'b0;
                end

                WAIT_X1, WAIT_X0, WAIT_X2: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                G_ON_0, G_ON_1, G_ON_PERM: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                G_OFF_PERM: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Combinational block: next state logic
    always @(*) begin
        next_state = state;

        case (state)
            A: begin
                // Stay in A while reset asserted
                // After reset deasserted, move to F_ONE for f=1 pulse
                if (resetn)
                    next_state = F_ONE;
                else
                    next_state = A;
            end

            F_ONE: begin
                // After asserting f=1 one cycle, start monitoring x pattern
                next_state = WAIT_X1;
            end

            WAIT_X1: begin
                // Wait for x=1 to start pattern 1,0,1
                if (x == 1'b1)
                    next_state = WAIT_X0;
                else
                    next_state = WAIT_X1;
            end

            WAIT_X0: begin
                // Wait for x=0 after x=1
                if (x == 1'b0)
                    next_state = WAIT_X2;
                else if (x == 1'b1)
                    // Still 1 means pattern restart attempt
                    next_state = WAIT_X0;
                else
                    next_state = WAIT_X0;
            end

            WAIT_X2: begin
                // Wait for x=1 to complete 1,0,1 pattern
                if (x == 1'b1)
                    next_state = G_ON_0;
                else if (x == 1'b0)
                    // Pattern broken, restart looking for x=1
                    next_state = WAIT_X1;
                else
                    next_state = WAIT_X2;
            end

            G_ON_0: begin
                // g=1 first cycle, monitor y
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_ON_1;
            end

            G_ON_1: begin
                // g=1 second cycle, monitor y
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_OFF_PERM;
            end

            G_ON_PERM: begin
                // Permanently hold g=1 until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Permanently hold g=0 until reset
                next_state = G_OFF_PERM;
            end

            default: begin
                // Safety fallback to reset state
                next_state = A;
            end
        endcase
    end

endmodule