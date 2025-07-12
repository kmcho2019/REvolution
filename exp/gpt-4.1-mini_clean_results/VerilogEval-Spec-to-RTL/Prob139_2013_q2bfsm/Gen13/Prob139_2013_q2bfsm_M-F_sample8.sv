module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding with parameters
    localparam [3:0]
        STATE_A           = 4'd0, // reset state: resetn asserted
        STATE_WAIT_RELEASE= 4'd1, // wait one clock after resetn deasserted
        STATE_B           = 4'd2, // f=1 pulse (one cycle)
        STATE_C0          = 4'd3, // wait x=1
        STATE_C1          = 4'd4, // got x=1, wait x=0
        STATE_C2          = 4'd5, // got 1,0 wait x=1
        STATE_D           = 4'd6, // g=1 pulse (one cycle)
        STATE_E0          = 4'd7, // monitor y cycle 1 with g=1
        STATE_E1          = 4'd8, // monitor y cycle 2 with g=1
        STATE_F           = 4'd9, // permanent g=1
        STATE_G           = 4'd10; // permanent g=0

    reg [3:0] state, next_state;

    // Sequential logic for state update (synchronous active-low reset)
    always @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                // Wait here while reset is asserted
                if (resetn)
                    next_state = STATE_WAIT_RELEASE;
                else
                    next_state = STATE_A;
            end

            STATE_WAIT_RELEASE: begin
                // Wait exactly one clock cycle after resetn is high before producing f=1
                next_state = STATE_B;
            end

            STATE_B: begin
                // f=1 one cycle done, begin monitoring x pattern
                next_state = STATE_C0;
            end

            STATE_C0: begin
                // Wait for x=1 to start pattern
                if (x == 1'b1)
                    next_state = STATE_C1;
                else
                    next_state = STATE_C0;
            end

            STATE_C1: begin
                // After receiving x=1, wait x=0 next cycle
                if (x == 1'b0)
                    next_state = STATE_C2;
                else
                    // If x not 0, pattern broken, restart from C0
                    next_state = STATE_C1;
            end

            STATE_C2: begin
                // After receiving x=1,0 sequence, wait x=1 next cycle to complete pattern
                if (x == 1'b1)
                    next_state = STATE_D;
                else
                    // If pattern breaks, restart monitoring from C0
                    next_state = STATE_C0;
            end

            STATE_D: begin
                // g=1 pulse after pattern detected, next monitor y input for two cycles
                next_state = STATE_E0;
            end

            STATE_E0: begin
                // First cycle monitoring y with g=1
                if (y == 1'b1)
                    next_state = STATE_F; // permanent g=1
                else
                    next_state = STATE_E1; // second chance cycle
            end

            STATE_E1: begin
                // Second cycle monitoring y with g=1
                if (y == 1'b1)
                    next_state = STATE_F; // permanent g=1
                else
                    next_state = STATE_G; // permanent g=0
            end

            STATE_F: begin
                // permanent g=1 until reset
                next_state = STATE_F;
            end

            STATE_G: begin
                // permanent g=0 until reset
                next_state = STATE_G;
            end

            default: next_state = STATE_A;
        endcase
    end

    // Output logic (Moore machine: outputs depend only on state)
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;

        case(state)
            STATE_B:      f = 1'b1; // one clock cycle pulse after reset release
            STATE_D:      g = 1'b1; // one clock cycle pulse after pattern detection
            STATE_E0:     g = 1'b1; // monitoring y cycle 1
            STATE_E1:     g = 1'b1; // monitoring y cycle 2
            STATE_F:      g = 1'b1; // permanent g=1
            default: begin
                // f=0, g=0 in all other states
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule