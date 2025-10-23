module TopModule(
    input        clk,
    input        resetn,
    input        x,
    input        y,
    output reg   f,
    output reg   g
);

    // State encoding using localparams
    localparam A           = 4'd0; // Reset state
    localparam F_ONE       = 4'd1; // f=1 for one cycle after reset
    localparam WAIT_X1     = 4'd2; // waiting for x=1
    localparam WAIT_X0     = 4'd3; // waiting for x=0 after x=1
    localparam WAIT_X2     = 4'd4; // waiting for x=1 to complete pattern 1,0,1
    localparam G_ON_0      = 4'd5; // g=1 first cycle, monitor y
    localparam G_ON_1      = 4'd6; // g=1 second cycle, monitor y
    localparam G_ON_PERM   = 4'd7; // g=1 permanently
    localparam G_OFF_PERM  = 4'd8; // g=0 permanently

    reg [3:0] state, next_state;

    // Sequential block for state and output updates
    always @(posedge clk) begin
        if (~resetn) begin
            // Synchronous active-low reset
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            // Outputs updated synchronously with state transitions below
            case (next_state)
                F_ONE: begin
                    f <= 1'b1;
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

    // Combinational block for next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            A: begin
                if (resetn)
                    next_state = F_ONE;
                else
                    next_state = A;
            end

            F_ONE: begin
                // After asserting f=1 one cycle, start waiting pattern
                next_state = WAIT_X1;
            end

            WAIT_X1: begin
                if (x == 1'b1)
                    next_state = WAIT_X0;
                else
                    next_state = WAIT_X1;
            end

            WAIT_X0: begin
                if (x == 1'b0)
                    next_state = WAIT_X2;
                else
                    next_state = WAIT_X0;
            end

            WAIT_X2: begin
                if (x == 1'b1)
                    next_state = G_ON_0;
                else if (x == 1'b0)
                    next_state = WAIT_X1; // pattern broken, restart
                else
                    next_state = WAIT_X2; // hold, but x only 1-bit, so else won't happen
            end

            G_ON_0: begin
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_ON_1;
            end

            G_ON_1: begin
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_OFF_PERM;
            end

            G_ON_PERM: begin
                // Stay here permanently until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Stay here permanently until reset
                next_state = G_OFF_PERM;
            end

            default: next_state = A;
        endcase
    end

endmodule