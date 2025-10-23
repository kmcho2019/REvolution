module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    localparam A          = 4'd0; // reset state
    localparam F_ONE      = 4'd1; // f=1 for one cycle after reset
    localparam WAIT_X1    = 4'd2; // waiting for x=1 (start pattern)
    localparam WAIT_X0    = 4'd3; // waiting for x=0 after x=1
    localparam WAIT_X2    = 4'd4; // waiting for x=1 to complete pattern 1,0,1
    localparam G_ON_0     = 4'd5; // g=1 first cycle, monitor y
    localparam G_ON_1     = 4'd6; // g=1 second cycle, monitor y
    localparam G_ON_PERM  = 4'd7; // g=1 permanently
    localparam G_OFF_PERM = 4'd8; // g=0 permanently

    reg [3:0] state, next_state;

    // Sequential logic: state transitions and output registers
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            // Outputs synchronous with state transitions
            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                F_ONE: begin
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

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: begin
                // Stay in A while reset asserted
                // When reset de-asserted, go to F_ONE (f=1 pulse)
                if (resetn)
                    next_state = F_ONE;
                else
                    next_state = A;
            end

            F_ONE: begin
                // After f=1 cycle, start monitoring x for pattern
                next_state = WAIT_X1;
            end

            WAIT_X1: begin
                // Wait for x=1 to start pattern
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
                    // Pattern broke, but new 1 could be pattern start
                    next_state = WAIT_X0; 
                else
                    next_state = WAIT_X0; // should never happen as x is 1 bit
            end

            WAIT_X2: begin
                // Wait for x=1 to complete 1,0,1 pattern
                if (x == 1'b1)
                    next_state = G_ON_0;
                else if (x == 1'b0)
                    // Pattern broke, restart detection
                    next_state = WAIT_X1;
                else
                    next_state = WAIT_X2; // should never happen
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
                // Hold g=1 permanently
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Hold g=0 permanently
                next_state = G_OFF_PERM;
            end

            default: begin
                // Safety fallback to reset state
                next_state = A;
            end
        endcase
    end

endmodule