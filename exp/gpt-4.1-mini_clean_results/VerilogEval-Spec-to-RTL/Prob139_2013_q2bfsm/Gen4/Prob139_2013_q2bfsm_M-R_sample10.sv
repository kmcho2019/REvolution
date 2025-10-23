module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // State encoding (one-hot-like for clarity)
    localparam [2:0]
        S_A      = 3'd0, // Reset state (idle)
        S_FONE   = 3'd1, // f=1 for one cycle after reset release
        S_WAIT1  = 3'd2, // waiting for first '1' in pattern on x
        S_WAIT0  = 3'd3, // got '1', waiting for '0'
        S_WAIT2  = 3'd4, // got '1','0', waiting for last '1'
        S_G_ON   = 3'd5, // g=1, monitor y up to 2 cycles
        S_G_OFF  = 3'd6; // g=0 permanently after y timeout

    reg [2:0] state, next_state;

    // Detect rising edge of resetn: from 0 to 1
    reg resetn_d;
    wire reset_release = ~resetn_d & resetn; // asserted only on cycle resetn goes high

    // Pattern monitor internal signals
    // y monitoring counter (0..2)
    reg [1:0] y_count;
    reg y_seen_flag;

    // State register and synchronous reset sampling
    always @(posedge clk) begin
        resetn_d <= resetn; // sample resetn for edge detection

        if (~resetn) begin
            state <= S_A;
            y_count <= 2'd0;
            y_seen_flag <= 1'b0;
        end else begin
            state <= next_state;

            // Manage y_count and y_seen_flag only in S_G_ON
            if (state == S_G_ON) begin
                // Increment counter up to 2 max
                if (y_count < 2)
                    y_count <= y_count + 1'b1;

                // Latch y_seen_flag if y=1 at any cycle in S_G_ON
                if (y == 1'b1)
                    y_seen_flag <= 1'b1;
            end else begin
                // Clear on leaving S_G_ON
                y_count <= 2'd0;
                y_seen_flag <= 1'b0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            S_A: begin
                if (reset_release)
                    next_state = S_FONE;
                else
                    next_state = S_A;
            end

            S_FONE: begin
                // One cycle f=1 pulse done, start pattern detection
                next_state = S_WAIT1;
            end

            S_WAIT1: begin
                // Waiting for first '1' in pattern 1,0,1
                if (x == 1'b1)
                    next_state = S_WAIT0;
                else
                    next_state = S_WAIT1;
            end

            S_WAIT0: begin
                // Got first '1', expecting '0'
                if (x == 1'b0)
                    next_state = S_WAIT2;
                else if (x == 1'b1)
                    // Stay in S_WAIT0, still waiting for 0
                    next_state = S_WAIT0;
                else
                    next_state = S_WAIT0;
            end

            S_WAIT2: begin
                // Got '1','0', expecting last '1'
                if (x == 1'b1)
                    next_state = S_G_ON; // pattern matched
                else if (x == 1'b0)
                    // Pattern broken, restart waiting for first '1'
                    next_state = S_WAIT1;
                else
                    next_state = S_WAIT2;
            end

            S_G_ON: begin
                if (y_seen_flag) begin
                    // y=1 detected within 2 cycles, hold g=1 forever
                    next_state = S_G_ON;
                end else if (y_count == 2 && !y_seen_flag) begin
                    // y not detected within 2 cycles, disable g permanently
                    next_state = S_G_OFF;
                end else begin
                    // Keep monitoring y
                    next_state = S_G_ON;
                end
            end

            S_G_OFF: begin
                // g=0 permanently until reset
                next_state = S_G_OFF;
            end

            default: next_state = S_A;
        endcase
    end

    // Output logic: Moore machine outputs assigned based on state
    always @(posedge clk) begin
        if (~resetn) begin
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            // f=1 only one cycle after reset release in S_FONE
            f <= (state == S_FONE);

            // g=1 only in S_G_ON; 0 elsewhere (including S_G_OFF)
            g <= (state == S_G_ON);
        end
    end

endmodule