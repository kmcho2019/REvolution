module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding for FSM (3 bits)
    typedef enum logic [2:0] {
        S_A      = 3'd0, // Reset state
        S_WAIT1  = 3'd1, // Waiting for first '1' in pattern (prefix length 0)
        S_WAIT0  = 3'd2, // Got '1', waiting for '0'
        S_WAIT2  = 3'd3, // Got '1','0', waiting for last '1'
        S_G_ON   = 3'd4, // g=1 active, monitoring y for up to 2 cycles
        S_G_OFF  = 3'd5  // g=0 permanent after y not seen within 2 cycles
    } state_t;

    state_t state, next_state;

    // Detect resetn rising edge synchronously to generate f pulse one cycle after resetn de-assertion
    reg resetn_d;      // delayed resetn to detect rising edge
    reg f_pulse_flag;  // one-cycle flag to generate f=1 pulse

    // y monitoring counter in S_G_ON
    reg [1:0] y_monitor_cnt;
    reg y_seen_flag;

    // Sequential logic
    always @(posedge clk) begin
        // Synchronous active low reset
        if (!resetn) begin
            state <= S_A;
            f <= 1'b0;
            g <= 1'b0;
            resetn_d <= 1'b0;
            f_pulse_flag <= 1'b0;
            y_monitor_cnt <= 2'd0;
            y_seen_flag <= 1'b0;
        end else begin
            // Delay resetn for edge detection
            resetn_d <= resetn;

            // Detect rising edge of resetn (reset release)
            if (~resetn_d & resetn) begin
                // Just after reset released, assert f pulse next cycle
                f_pulse_flag <= 1'b1;
            end else begin
                // Clear f_pulse_flag after one cycle
                if (f_pulse_flag)
                    f_pulse_flag <= 1'b0;
            end

            // State update
            state <= next_state;

            // f output: 1 only for one cycle right after reset release
            f <= f_pulse_flag;

            // g output logic
            // g=1 in S_G_ON, else 0
            g <= (state == S_G_ON);

            // y monitoring logic only in S_G_ON
            if (state == S_G_ON) begin
                // Check if y=1 occurred
                if (y == 1'b1)
                    y_seen_flag <= 1'b1;

                // Increment monitor counter up to 2
                if (y_monitor_cnt < 2)
                    y_monitor_cnt <= y_monitor_cnt + 1'b1;
            end else begin
                // Reset y monitoring signals outside S_G_ON
                y_monitor_cnt <= 2'd0;
                y_seen_flag <= 1'b0;
            end
        end
    end

    // Combinational next state logic: classic sequence detector for 1,0,1 on x
    always @(*) begin
        next_state = state;

        case (state)
            S_A: begin
                // Wait for reset release, then go to waiting for pattern
                if (resetn)
                    next_state = S_WAIT1;
                else
                    next_state = S_A;
            end

            S_WAIT1: begin
                // Waiting for first '1'
                if (x == 1'b1)
                    next_state = S_WAIT0;
                else
                    next_state = S_WAIT1;
            end

            S_WAIT0: begin
                // Got first '1', expect '0'
                if (x == 1'b0)
                    next_state = S_WAIT2;
                else if (x == 1'b1)
                    // Stay in S_WAIT0 because still waiting for '0', a new '1' does not advance
                    next_state = S_WAIT0;
                else
                    next_state = S_WAIT0; // defensive
            end

            S_WAIT2: begin
                // Got '1','0', expect last '1'
                if (x == 1'b1)
                    next_state = S_G_ON; // Pattern matched 1,0,1
                else if (x == 1'b0)
                    // Pattern broken, restart detection
                    next_state = S_WAIT1;
                else
                    next_state = S_WAIT2; // defensive
            end

            S_G_ON: begin
                // g=1 active, monitoring y for up to 2 cycles
                // If y seen in time, remain here forever
                if (y_seen_flag)
                    next_state = S_G_ON;
                // If y not seen and 2 cycles elapsed, go to g=0 permanent
                else if ((y_monitor_cnt == 2) && !y_seen_flag)
                    next_state = S_G_OFF;
                else
                    next_state = S_G_ON;
            end

            S_G_OFF: begin
                // Permanently g=0 until reset
                next_state = S_G_OFF;
            end

            default: next_state = S_A;
        endcase
    end

endmodule