module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum reg [3:0] {
        RESET     = 4'd0, // reset asserted
        F_PULSE   = 4'd1, // f=1 for 1 cycle after reset release
        WAIT_X1   = 4'd2, // waiting for x=1 first pattern bit
        WAIT_X0   = 4'd3, // waiting for x=0 second pattern bit
        WAIT_X2   = 4'd4, // waiting for x=1 third pattern bit
        G_PULSE   = 4'd5, // g=1 one cycle pulse after pattern detected
        Y_WAIT0   = 4'd6, // wait 1st cycle for y=1
        Y_WAIT1   = 4'd7, // wait 2nd cycle for y=1
        G_ON      = 4'd8, // g=1 permanently
        G_OFF     = 4'd9  // g=0 permanently
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= RESET;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            // Moore outputs depend only on next state to avoid glitches
            case (next_state)
                F_PULSE: f <= 1'b1;
                default: f <= 1'b0;
            endcase

            case (next_state)
                G_PULSE,
                G_ON: g <= 1'b1;
                default: g <= 1'b0;
            endcase
        end
    end

    always @(*) begin
        // Default next state is current state
        next_state = state;

        case (state)
            RESET: begin
                if (resetn)
                    next_state = F_PULSE;
            end
            F_PULSE: begin
                // After asserting f=1 for one cycle, start pattern detection
                next_state = WAIT_X1;
            end
            WAIT_X1: begin
                // Wait for x=1 on current cycle
                if (x == 1'b1)
                    next_state = WAIT_X0;
                else
                    next_state = WAIT_X1; // stay waiting
            end
            WAIT_X0: begin
                // Next cycle wait for x=0
                if (x == 1'b0)
                    next_state = WAIT_X2;
                else
                    next_state = WAIT_X1; // restart pattern if fail
            end
            WAIT_X2: begin
                // Next cycle wait for x=1
                if (x == 1'b1)
                    next_state = G_PULSE;
                else
                    next_state = WAIT_X1; // restart pattern if fail
            end
            G_PULSE: begin
                // One cycle pulse g=1, then start monitoring y
                next_state = Y_WAIT0;
            end
            Y_WAIT0: begin
                if (y == 1'b1)
                    next_state = G_ON;
                else
                    next_state = Y_WAIT1;
            end
            Y_WAIT1: begin
                if (y == 1'b1)
                    next_state = G_ON;
                else
                    next_state = G_OFF;
            end
            G_ON: begin
                // hold g=1 permanently until reset
                if (!resetn)
                    next_state = RESET;
                else
                    next_state = G_ON;
            end
            G_OFF: begin
                // hold g=0 permanently until reset
                if (!resetn)
                    next_state = RESET;
                else
                    next_state = G_OFF;
            end
            default: begin
                next_state = RESET;
            end
        endcase
    end

endmodule