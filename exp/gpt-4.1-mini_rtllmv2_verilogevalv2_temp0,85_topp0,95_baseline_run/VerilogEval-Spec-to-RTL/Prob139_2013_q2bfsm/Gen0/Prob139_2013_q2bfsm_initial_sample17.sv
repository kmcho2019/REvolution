module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [3:0] {
        A = 4'd0,          // Reset state
        ASSERT_F = 4'd1,   // f=1 for one cycle
        MONITOR_X1 = 4'd2, // waiting for first 1 in pattern x=1
        MONITOR_X2 = 4'd3, // waiting for x=0 second bit
        MONITOR_X3 = 4'd4, // waiting for x=1 third bit
        SET_G = 4'd5,      // g=1 set next cycle, start monitoring y
        MONITOR_Y1 = 4'd6, // 1st cycle waiting for y=1
        MONITOR_Y2 = 4'd7, // 2nd cycle waiting for y=1
        G_PERMANENT_1 = 4'd8, // g=1 permanently
        G_PERMANENT_0 = 4'd9  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // State register with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) 
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        // Defaults
        next_state = state;
        f = 1'b0;
        g = 1'b0;

        case(state)
            A: begin
                // On reset low, stay here
                // When resetn asserted, on next clock go to ASSERT_F
                // Outputs are 0 here
                if (resetn)
                    next_state = ASSERT_F;
            end
            ASSERT_F: begin
                // Output f=1 for one clock cycle
                f = 1'b1;
                next_state = MONITOR_X1;
            end
            MONITOR_X1: begin
                // wait for x=1
                if (x == 1'b1)
                    next_state = MONITOR_X2;
                else
                    next_state = MONITOR_X1; // keep waiting
            end
            MONITOR_X2: begin
                // wait for x=0
                if (x == 1'b0)
                    next_state = MONITOR_X3;
                else if (x == 1'b1)
                    next_state = MONITOR_X2; // remain here if x=1, as pattern must be 1,0,1
                else
                    next_state = MONITOR_X1; // if x neither 1 or 0 (shouldn't happen), restart pattern
            end
            MONITOR_X3: begin
                // wait for x=1
                if (x == 1'b1)
                    next_state = SET_G;
                else if (x == 1'b0)
                    next_state = MONITOR_X1; // pattern broken, restart from first 1
                else
                    next_state = MONITOR_X1;
            end
            SET_G: begin
                // Set g=1 on this cycle, next monitor y for up to two cycles
                g = 1'b1;
                next_state = MONITOR_Y1;
            end
            MONITOR_Y1: begin
                g = 1'b1;
                if (y == 1'b1)
                    next_state = G_PERMANENT_1; // y=1 within first cycle, stay g=1 permanently
                else
                    next_state = MONITOR_Y2; // wait second cycle
            end
            MONITOR_Y2: begin
                g = 1'b1;
                if (y == 1'b1)
                    next_state = G_PERMANENT_1; // y=1 within second cycle
                else
                    next_state = G_PERMANENT_0; // y never=1 within 2 cycles
            end
            G_PERMANENT_1: begin
                g = 1'b1;
                next_state = G_PERMANENT_1; // stay here until reset
            end
            G_PERMANENT_0: begin
                g = 1'b0;
                next_state = G_PERMANENT_0; // stay here until reset
            end
            default: begin
                next_state = A;
            end
        endcase
    end

endmodule