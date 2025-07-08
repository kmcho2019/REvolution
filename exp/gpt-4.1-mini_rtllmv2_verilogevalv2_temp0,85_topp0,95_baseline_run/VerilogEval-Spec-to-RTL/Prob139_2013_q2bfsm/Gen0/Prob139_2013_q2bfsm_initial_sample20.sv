module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [3:0] {
        A = 4'd0,          // initial state, waiting for resetn
        F_HIGH = 4'd1,     // output f=1 for one cycle
        WAIT_X1 = 4'd2,    // wait for first '1' in x sequence
        WAIT_X0 = 4'd3,    // wait for '0' after first '1'
        WAIT_X2 = 4'd4,    // wait for second '1' in x sequence
        G_HIGH = 4'd5,     // g=1, start monitoring y
        G_HIGH_Y1 = 4'd6,  // y monitored 1 cycle with no '1' yet
        G_HIGH_PERM = 4'd7,// g=1 permanently after y=1 detected
        G_LOW_PERM = 4'd8  // g=0 permanently after y not detected in 2 cycles
    } state_t;

    state_t state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic and output logic
    always @* begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;
        next_state = state;

        case(state)
            A: begin
                // resetn asserted: stay in A with f=0,g=0
                // When resetn deasserted, move to F_HIGH to pulse f=1
                if (resetn)
                    next_state = F_HIGH;
            end
            F_HIGH: begin
                // Output f=1 for one cycle
                f = 1'b1;
                // After this cycle, start monitoring x sequence, expect first '1'
                next_state = WAIT_X1;
            end
            WAIT_X1: begin
                // f=0, g=0
                // Wait for x=1 to start sequence 101
                if (x == 1'b1)
                    next_state = WAIT_X0; // got first '1', now expect '0'
                else
                    next_state = WAIT_X1; // keep waiting for first '1'
            end
            WAIT_X0: begin
                // Wait for x=0 (second bit of sequence)
                if (x == 1'b0)
                    next_state = WAIT_X2; // got '0', expect last '1'
                else if (x == 1'b1)
                    next_state = WAIT_X0; // if x=1 here, still wait for 0
                else
                    next_state = WAIT_X0;
            end
            WAIT_X2: begin
                // Wait for x=1 (third bit of sequence)
                if (x == 1'b1)
                    next_state = G_HIGH; // sequence 1,0,1 detected
                else if (x == 1'b0)
                    next_state = WAIT_X1; // restart pattern search from first '1'
                else
                    next_state = WAIT_X2;
            end
            G_HIGH: begin
                // g=1
                g = 1'b1;
                // start monitoring y for up to 2 clock cycles
                // if y=1 immediately, go to permanent g=1
                if (y == 1'b1)
                    next_state = G_HIGH_PERM;
                else
                    next_state = G_HIGH_Y1;
            end
            G_HIGH_Y1: begin
                // g=1
                g = 1'b1;
                // Second cycle of monitoring y
                if (y == 1'b1)
                    next_state = G_HIGH_PERM;
                else
                    next_state = G_LOW_PERM;
            end
            G_HIGH_PERM: begin
                // g=1 permanently until reset
                g = 1'b1;
                next_state = G_HIGH_PERM;
            end
            G_LOW_PERM: begin
                // g=0 permanently until reset
                g = 1'b0;
                next_state = G_LOW_PERM;
            end
            default: begin
                // default fallback to reset state
                next_state = A;
            end
        endcase
    end

endmodule