module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // FSM states
    typedef enum logic [3:0] {
        STATE_A  = 4'd0, // Reset state, f=0, g=0
        STATE_B  = 4'd1, // f=1 one cycle after reset deasserted
        STATE_C0 = 4'd2, // Waiting for first '1' in pattern on x
        STATE_C1 = 4'd3, // Got first '1', waiting for '0'
        STATE_C2 = 4'd4, // Got '10', waiting for last '1'
        STATE_D  = 4'd5, // g=1 one cycle pulse after pattern detected
        STATE_E  = 4'd6, // Monitor y up to two cycles with g=1
        STATE_F  = 4'd7, // g=1 permanently
        STATE_G  = 4'd8  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // Counter for y monitoring in STATE_E (0..2)
    reg [1:0] y_count;

    // Sequential logic: state and counters update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= STATE_A;
            y_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == STATE_E)
                y_count <= y_count + 2'd1;
            else
                y_count <= 2'd0;
        end
    end

    // Next state logic and outputs (Moore)
    always @(*) begin
        // Defaults
        next_state = state;
        f = 1'b0;
        g = 1'b0;

        case (state)
            STATE_A: begin
                // Wait for reset deassertion
                if (resetn)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end

            STATE_B: begin
                // Output f=1 for exactly one cycle, then move to pattern detection
                f = 1'b1;
                next_state = STATE_C0;
            end

            // Pattern detection FSM on x input
            STATE_C0: begin
                // Waiting for first '1'
                if (x == 1'b1)
                    next_state = STATE_C1;
                else
                    next_state = STATE_C0;
            end

            STATE_C1: begin
                // After first '1', expect '0'
                if (x == 1'b0)
                    next_state = STATE_C2;
                else if (x == 1'b1)
                    // Stay in STATE_C1 since '1' again can be new start
                    next_state = STATE_C1;
                else
                    next_state = STATE_C0;
            end

            STATE_C2: begin
                // After "10", expect last '1' to complete "101"
                if (x == 1'b1)
                    next_state = STATE_D;
                else if (x == 1'b0)
                    // Restart pattern detection if next is 0
                    next_state = STATE_C0;
                else
                    next_state = STATE_C0;
            end

            STATE_D: begin
                // g=1 one cycle pulse after pattern detected
                g = 1'b1;
                next_state = STATE_E;
            end

            STATE_E: begin
                // Hold g=1 while monitoring y input for up to two cycles
                g = 1'b1;
                if (y == 1'b1) begin
                    // If y=1 detected anytime, go to permanent g=1
                    next_state = STATE_F;
                end else if (y_count == 2'd1) begin
                    // After two cycles (counting from 0), if y never 1, go g=0 permanently
                    next_state = STATE_G;
                end else begin
                    next_state = STATE_E;
                end
            end

            STATE_F: begin
                // g=1 permanently until reset
                g = 1'b1;
                next_state = STATE_F;
            end

            STATE_G: begin
                // g=0 permanently until reset (default g=0)
                next_state = STATE_G;
            end

            default: begin
                next_state = STATE_A;
            end
        endcase
    end

endmodule