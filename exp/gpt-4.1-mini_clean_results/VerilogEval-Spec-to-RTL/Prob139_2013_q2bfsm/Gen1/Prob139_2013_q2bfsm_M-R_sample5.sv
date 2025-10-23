module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding with 4-bit width to hold all states uniquely
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

    // Sequential block: state update on rising clock edge, synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Combinational block: determine next state and outputs based on current state and inputs
    always @(*) begin
        // Defaults
        next_state = state;
        f = 1'b0;
        g = 1'b0;

        case (state)
            A: begin
                // On reset asserted, remain in A with outputs low
                // On reset deasserted, go to F_ONE and prepare f=1
                if (resetn)
                    next_state = F_ONE;
                else
                    next_state = A;
                // f and g remain 0
            end

            F_ONE: begin
                // Assert f=1 for one cycle, then start monitoring x pattern
                f = 1'b1;
                g = 1'b0;
                next_state = WAIT_X1;
            end

            WAIT_X1: begin
                f = 1'b0;
                g = 1'b0;
                // Wait for x=1 to start pattern
                if (x == 1'b1)
                    next_state = WAIT_X0;
                else
                    next_state = WAIT_X1;
            end

            WAIT_X0: begin
                f = 1'b0;
                g = 1'b0;
                // Wait for x=0 after x=1
                if (x == 1'b0)
                    next_state = WAIT_X2;
                else
                    next_state = WAIT_X0; // keep waiting
            end

            WAIT_X2: begin
                f = 1'b0;
                g = 1'b0;
                // Wait for x=1 to complete pattern 1,0,1
                if (x == 1'b1)
                    next_state = G_ON_0;
                else if (x == 1'b0)
                    // Pattern broken, restart pattern search
                    next_state = WAIT_X1;
                else
                    next_state = WAIT_X2;
            end

            G_ON_0: begin
                f = 1'b0;
                g = 1'b1;
                // Monitor y first cycle
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_ON_1;
            end

            G_ON_1: begin
                f = 1'b0;
                g = 1'b1;
                // Monitor y second cycle
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_OFF_PERM;
            end

            G_ON_PERM: begin
                // Permanently keep g=1 until reset
                f = 1'b0;
                g = 1'b1;
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Permanently keep g=0 until reset
                f = 1'b0;
                g = 1'b0;
                next_state = G_OFF_PERM;
            end

            default: begin
                // Safety fallback to reset state
                f = 1'b0;
                g = 1'b0;
                next_state = A;
            end
        endcase
    end

endmodule