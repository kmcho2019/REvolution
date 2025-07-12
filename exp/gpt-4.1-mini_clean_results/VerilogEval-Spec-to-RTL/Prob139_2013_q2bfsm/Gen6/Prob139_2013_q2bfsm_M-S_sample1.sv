module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (simple Moore FSM)
    typedef enum logic [3:0] {
        A             = 4'd0, // Reset state, f=0,g=0
        F_PULSE       = 4'd1, // f=1 one cycle after reset deassert
        X_WAIT1       = 4'd2, // waiting for x=1 (first pattern bit)
        X_WAIT0       = 4'd3, // got x=1, waiting for x=0 (second pattern bit)
        X_WAIT1B      = 4'd4, // got x=0, waiting for x=1 (third pattern bit)
        G_MONITOR_Y_1 = 4'd5, // g=1, first cycle monitoring y=1
        G_MONITOR_Y_2 = 4'd6, // g=1, second cycle monitoring y=1
        G_ON_PERM     = 4'd7, // g=1 permanently
        G_OFF_PERM    = 4'd8  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // Sequential state transition
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            // Moore outputs based on state
            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                F_PULSE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                X_WAIT1, X_WAIT0, X_WAIT1B: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                G_MONITOR_Y_1, G_MONITOR_Y_2, G_ON_PERM: begin
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
        next_state = state;

        case (state)
            A: begin
                // Hold in A while reset asserted
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: begin
                // After outputting f=1 one cycle, start pattern detection on x
                next_state = X_WAIT1;
            end

            X_WAIT1: begin
                // Waiting for x=1 (first bit)
                if (x == 1'b1)
                    next_state = X_WAIT0;
                else
                    next_state = X_WAIT1;
            end

            X_WAIT0: begin
                // Waiting for x=0 (second bit)
                if (x == 1'b0)
                    next_state = X_WAIT1B;
                else if (x == 1'b1)
                    next_state = X_WAIT0; // stay here if x=1 again
                else
                    next_state = X_WAIT1;  // fallback if needed
            end

            X_WAIT1B: begin
                // Waiting for x=1 (third bit)
                if (x == 1'b1)
                    next_state = G_MONITOR_Y_1;
                else
                    next_state = X_WAIT1; // restart pattern detection on failure
            end

            G_MONITOR_Y_1: begin
                // g=1, first cycle monitoring y=1
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_MONITOR_Y_2;
            end

            G_MONITOR_Y_2: begin
                // g=1, second cycle monitoring y=1
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_OFF_PERM;
            end

            G_ON_PERM: begin
                // Stay here forever until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Stay here forever until reset
                next_state = G_OFF_PERM;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule