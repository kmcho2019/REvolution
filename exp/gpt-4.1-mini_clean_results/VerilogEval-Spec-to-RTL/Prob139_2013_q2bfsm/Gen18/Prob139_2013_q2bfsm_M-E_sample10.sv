module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum reg [3:0] {
        // Define states with descriptive names
        A  = 4'd0,  // Reset state, f=0, g=0
        B  = 4'd1,  // Pulse f=1 for one cycle after reset
        C1 = 4'd2,  // Wait for x=1 (pattern detection step 1)
        C2 = 4'd3,  // Wait for x=0 (pattern detection step 2)
        C3 = 4'd4,  // Wait for x=1 (pattern detection step 3)
        D  = 4'd5,  // Pulse g=1 for one cycle after pattern detected
        E1 = 4'd6,  // Hold g=1, monitor y, first cycle
        E2 = 4'd7,  // Hold g=1, monitor y, second cycle
        F  = 4'd8,  // g=1 permanent
        G  = 4'd9   // g=0 permanent
    } state_t;

    state_t state, next_state;
    reg [1:0] y_monitor_count; // counts cycles monitoring y in E1 and E2

    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous reset active low
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
            y_monitor_count <= 2'd0;
        end else begin
            state <= next_state;

            // Moore outputs depend only on current state (before state update)
            case (state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_monitor_count <= 2'd0;
                end
                B: begin
                    f <= 1'b1;
                    g <= 1'b0;
                    y_monitor_count <= 2'd0;
                end
                C1, C2, C3: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_monitor_count <= 2'd0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    y_monitor_count <= 2'd0;
                end
                E1, E2: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    y_monitor_count <= (state == E1) ? 2'd1 : 2'd2;
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    // y_monitor_count irrelevant here
                end
                G: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    // y_monitor_count irrelevant here
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_monitor_count <= 2'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold state
        case (state)
            A: begin
                if (resetn)
                    next_state = B; // after reset release, pulse f
                else
                    next_state = A;
            end
            B: begin
                // pulse f done, start pattern detection on x
                next_state = C1;
            end
            C1: begin
                // Wait for x=1
                if (x == 1'b1)
                    next_state = C2;
                else
                    next_state = C1;
            end
            C2: begin
                // Wait for x=0
                if (x == 1'b0)
                    next_state = C3;
                else
                    next_state = C2;
            end
            C3: begin
                // Wait for x=1
                if (x == 1'b1)
                    next_state = D; // pattern detected
                else
                    next_state = C3;
            end
            D: begin
                // Pulse g=1 done, start monitoring y for two cycles
                next_state = E1;
            end
            E1: begin
                // Hold g=1, first cycle monitoring y
                if (y == 1'b1)
                    next_state = F; // y=1 detected, hold g=1 permanent
                else
                    next_state = E2; // continue to second cycle
            end
            E2: begin
                // Hold g=1, second cycle monitoring y
                if (y == 1'b1)
                    next_state = F; // y=1 detected, hold g=1 permanent
                else
                    next_state = G; // y=1 not detected within 2 cycles, g=0 permanent
            end
            F: begin
                // g=1 permanent state
                next_state = F;
            end
            G: begin
                // g=0 permanent state
                next_state = G;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

endmodule