module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // States encoding
    typedef enum logic [2:0] {
        S_A      = 3'd0, // Reset / idle state
        S_FONE   = 3'd1, // f=1 for one cycle after reset release
        S_WAIT1  = 3'd2, // waiting for first '1' in pattern on x
        S_WAIT0  = 3'd3, // got 1, waiting for 0
        S_WAIT2  = 3'd4, // got 1,0 waiting for last 1
        S_G_ON   = 3'd5, // g=1 active, monitor y for up to 2 cycles
        S_G_OFF  = 3'd6  // g=0 permanently after y not seen within 2 cycles
    } state_t;

    state_t state, next_state;

    // Counter to track number of y cycles elapsed in S_G_ON state
    reg [1:0] y_count;
    reg y_seen; // flag if y=1 occurred within 2 cycles in S_G_ON

    // Sequential state update and output registers
    always @(posedge clk) begin
        if (~resetn) begin
            state <= S_A;
            f <= 1'b0;
            g <= 1'b0;
            y_count <= 2'd0;
            y_seen <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs assigned according to current state
            // f=1 only in S_FONE state, else 0
            f <= (state == S_FONE);

            // g=1 in S_G_ON, 0 otherwise
            g <= (state == S_G_ON);

            // Manage y_count and y_seen only in S_G_ON
            if (state == S_G_ON) begin
                // Update y_seen flag if y=1 detected
                if (y == 1'b1)
                    y_seen <= 1'b1;

                // Increment y_count unless maxed at 2
                if (y_count < 2)
                    y_count <= y_count + 1'b1;
            end else begin
                // Reset y_count and y_seen outside G_ON
                y_count <= 2'd0;
                y_seen <= 1'b0;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            S_A: begin
                if (resetn)
                    next_state = S_FONE;
                else
                    next_state = S_A;
            end

            S_FONE: begin
                // After f=1 pulse, start monitoring x pattern
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
                // After seeing '1', expecting '0'
                if (x == 1'b0)
                    next_state = S_WAIT2;
                else if (x == 1'b1)
                    next_state = S_WAIT0; // stay here, still waiting for 0 but got 1 again
                else
                    next_state = S_WAIT0; // defensive
            end

            S_WAIT2: begin
                // After '1,0', expecting last '1' to complete pattern
                if (x == 1'b1)
                    next_state = S_G_ON; // pattern matched; go to G_ON
                else if (x == 1'b0)
                    next_state = S_WAIT1; // pattern broken, restart waiting for 1
                else
                    next_state = S_WAIT2;
            end

            S_G_ON: begin
                // Monitor y for at most 2 clock cycles after g=1 set
                if (y_seen)
                    // y=1 seen within 2 cycles, remain here forever with g=1
                    next_state = S_G_ON;
                else if (y_count == 2 && !y_seen)
                    // y not seen in 2 cycles, move to G_OFF permanently (g=0)
                    next_state = S_G_OFF;
                else
                    next_state = S_G_ON; // keep monitoring
            end

            S_G_OFF: begin
                // Permanently g=0 until reset; stay here
                next_state = S_G_OFF;
            end

            default: begin
                next_state = S_A;
            end
        endcase
    end

endmodule