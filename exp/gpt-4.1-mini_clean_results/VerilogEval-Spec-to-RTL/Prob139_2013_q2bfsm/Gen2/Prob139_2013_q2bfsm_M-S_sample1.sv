module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding: 3 bits enough for 6 states
    localparam 
        A           = 3'd0, // Reset state
        F_ONE       = 3'd1, // f=1 for one cycle after reset
        WAIT_X1     = 3'd2, // Waiting for x=1 (start pattern)
        WAIT_X0     = 3'd3, // Waiting for x=0 after x=1
        WAIT_X2     = 3'd4, // Waiting for x=1 to complete pattern 1,0,1
        G_ON        = 3'd5; // g=1 active, monitoring y for max 2 cycles or permanent

    reg [2:0] state, next_state;
    reg [1:0] y_monitor_count; // Counts up to 2 cycles monitoring y

    // Sequential logic: state updates, outputs registered
    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
            y_monitor_count <= 2'd0;
        end else begin
            state <= next_state;

            // Output f asserted only one cycle in F_ONE
            f <= (next_state == F_ONE);

            // Output g depends on state
            if (next_state == G_ON) begin
                g <= 1'b1;
                // y_monitor_count updates handled below
            end else if (state == G_ON && next_state != G_ON) begin
                // Leaving G_ON state, g may go low
                g <= 1'b0;
            end else if (next_state != G_ON) begin
                g <= 1'b0;
            end

            // Update y_monitor_count only in G_ON state
            if (state == G_ON) begin
                if (y == 1'b1) begin
                    // y=1 seen, lock count to 2 for permanent g=1
                    y_monitor_count <= 2'd2;
                end else if (y_monitor_count < 2) begin
                    // Increment count if less than 2 and y still 0
                    y_monitor_count <= y_monitor_count + 1'b1;
                end
            end else begin
                y_monitor_count <= 2'd0;
            end
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state;

        case(state)
            A: begin
                if (resetn)
                    next_state = F_ONE;
                else
                    next_state = A;
            end

            F_ONE: begin
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
                else if (x == 1'b1)
                    next_state = WAIT_X0; // stay waiting for zero after one
                else
                    next_state = WAIT_X0;
            end

            WAIT_X2: begin
                if (x == 1'b1)
                    next_state = G_ON;
                else if (x == 1'b0)
                    next_state = WAIT_X1; // pattern broken, restart
                else
                    next_state = WAIT_X2;
            end

            G_ON: begin
                // If y_monitor_count reached 2, decide permanent g=1 or 0
                if (y_monitor_count == 2) begin
                    // If y seen at least once during these cycles,
                    // remain in G_ON indefinitely
                    if (y == 1'b1)
                        next_state = G_ON;
                    else begin
                        // If y never seen in first two cycles, g=0 permanently
                        // But g=0 is indicated by leaving G_ON and no more g=1
                        // So transition back to A or G_OFF equivalent behavior is to stay here but turn off g
                        // Simplify by staying here with g=0
                        next_state = A; // returning to A simulates g=0 permanently until reset
                    end
                end else begin
                    next_state = G_ON;
                end
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule