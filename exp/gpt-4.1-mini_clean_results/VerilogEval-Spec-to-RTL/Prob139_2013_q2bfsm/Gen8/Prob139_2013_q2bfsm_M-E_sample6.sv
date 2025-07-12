module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        A             = 3'd0, // Reset state
        F_PULSE       = 3'd1, // f=1 for one cycle after resetn released
        MONITOR_X     = 3'd2, // Monitor x for pattern 1,0,1
        G_ON_MONITOR_Y= 3'd3, // g=1, monitor y for up to two cycles
        G_ON_PERM     = 3'd4, // g=1 permanently
        G_OFF_PERM    = 3'd5; // g=0 permanently

    reg [2:0] state, next_state;

    // Shift register for last 3 bits of x (only updated in MONITOR_X)
    reg [2:0] x_shift, next_x_shift;

    // Counter for number of y cycles monitored in G_ON_MONITOR_Y (0 to 2)
    reg [1:0] y_monitor_cnt, next_y_monitor_cnt;

    // State and auxiliary registers update on clock
    always @(posedge clk) begin
        if (!resetn) begin
            state          <= A;
            x_shift        <= 3'b000;
            y_monitor_cnt  <= 2'd0;
            f              <= 1'b0;
            g              <= 1'b0;
        end else begin
            state          <= next_state;
            x_shift        <= next_x_shift;
            y_monitor_cnt  <= next_y_monitor_cnt;
            f              <= (next_state == F_PULSE); // f=1 exactly in F_PULSE state
            // g depends on state:
            // g=1 in G_ON_MONITOR_Y and G_ON_PERM
            // g=0 elsewhere including G_OFF_PERM
            if (next_state == G_ON_MONITOR_Y || next_state == G_ON_PERM)
                g <= 1'b1;
            else
                g <= 1'b0;
        end
    end

    // Next state and aux registers combinational logic
    always @(*) begin
        // Defaults
        next_state        = state;
        next_x_shift      = x_shift;
        next_y_monitor_cnt= y_monitor_cnt;

        case(state)
            A: begin
                // Stay in A while resetn=0; when resetn=1 go to F_PULSE next clock
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
                next_x_shift = 3'b000; // clear shift register in reset
                next_y_monitor_cnt = 2'd0;
            end

            F_PULSE: begin
                // After one cycle with f=1, move to MONITOR_X
                next_state = MONITOR_X;
                next_x_shift = 3'b000; // clear shift on entry
                next_y_monitor_cnt = 2'd0;
            end

            MONITOR_X: begin
                // Shift x into shift register
                next_x_shift = {x_shift[1:0], x};
                // Check if pattern 1,0,1 detected (3'b101)
                if ({x_shift[1:0], x} == 3'b101) begin
                    next_state = G_ON_MONITOR_Y;
                    next_y_monitor_cnt = 2'd0;
                end else begin
                    next_state = MONITOR_X;
                    next_y_monitor_cnt = 2'd0;
                end
            end

            G_ON_MONITOR_Y: begin
                // Increment y_monitor_cnt up to 2
                if (y_monitor_cnt < 2)
                    next_y_monitor_cnt = y_monitor_cnt + 1'b1;
                else
                    next_y_monitor_cnt = y_monitor_cnt; // saturate at 2

                // Check y input
                if (y == 1'b1) begin
                    next_state = G_ON_PERM;
                end else if (y_monitor_cnt == 2) begin
                    // two cycles elapsed and no y=1 seen
                    next_state = G_OFF_PERM;
                end else begin
                    next_state = G_ON_MONITOR_Y;
                end
                next_x_shift = 3'b000; // not used here
            end

            G_ON_PERM: begin
                // Stay here until reset
                next_state = G_ON_PERM;
                next_x_shift = 3'b000;
                next_y_monitor_cnt = 2'd0;
            end

            G_OFF_PERM: begin
                // Stay here until reset
                next_state = G_OFF_PERM;
                next_x_shift = 3'b000;
                next_y_monitor_cnt = 2'd0;
            end

            default: begin
                next_state = A;
                next_x_shift = 3'b000;
                next_y_monitor_cnt = 2'd0;
            end
        endcase
    end

endmodule