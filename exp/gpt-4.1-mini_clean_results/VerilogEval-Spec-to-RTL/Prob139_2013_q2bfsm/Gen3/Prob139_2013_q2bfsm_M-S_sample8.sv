module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum reg [3:0] {
        A        = 4'd0,  // Reset state
        F_PULSE  = 4'd1,  // f=1 one cycle after reset
        X1       = 4'd2,  // detected first x=1 in sequence
        X10      = 4'd3,  // detected x=1 then x=0
        X101     = 4'd4,  // detected x=1,0,1 sequence completed
        MONITOR_Y= 4'd5,  // g=1 monitoring y for 2 cycles
        G_ON     = 4'd6,  // permanent g=1
        G_OFF    = 4'd7   // permanent g=0
    } state_t;

    state_t state, next_state;

    reg [1:0] y_count; // counts 0..2 for y monitoring

    // Sequential: State and counter update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            y_count <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            // Output and counter updates depend on state transitions below
            // f is asserted only in F_PULSE state
            // g is asserted in MONITOR_Y and G_ON states

            // y_count increments only in MONITOR_Y state
            if (state == MONITOR_Y)
                y_count <= y_count + 1;
            else
                y_count <= 2'd0;

            // f and g update combinationally with state but registered here for stable outputs
            case (next_state)
                F_PULSE: f <= 1'b1;
                default: f <= 1'b0;
            endcase

            case (next_state)
                MONITOR_Y: g <= 1'b1;
                G_ON:      g <= 1'b1;
                default:   g <= 1'b0;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            A: begin
                // Wait for reset release
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: begin
                // After one clock pulse f=1, start detecting x sequence
                if (x == 1'b1)
                    next_state = X1;
                else
                    next_state = A; // if x!=1 start over sequence detection after F_PULSE
            end

            X1: begin
                // Wait for x=0 next clock
                if (x == 1'b0)
                    next_state = X10;
                else if (x == 1'b1)
                    next_state = X1; // stay here if x=1 again, waiting for 0
                else
                    next_state = A; // safety fallback (x only 1 bit, so else won't happen)
            end

            X10: begin
                // Wait for x=1 next clock to complete 101
                if (x == 1'b1)
                    next_state = MONITOR_Y;
                else if (x == 1'b0)
                    next_state = A; // sequence broken, restart
                else
                    next_state = A; // safety fallback
            end

            MONITOR_Y: begin
                // g=1 here, monitor y for up to 2 clock cycles
                if (y == 1'b1)
                    next_state = G_ON;    // maintain g=1 permanently
                else if (y_count == 2'd1)
                    next_state = G_OFF;   // after 2 cycles with no y=1, g=0 permanently
                else
                    next_state = MONITOR_Y; // keep monitoring
            end

            G_ON: begin
                // Hold g=1 permanently until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = G_ON;
            end

            G_OFF: begin
                // Hold g=0 permanently until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = G_OFF;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule