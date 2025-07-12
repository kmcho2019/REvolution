module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

// State encoding:
// Use 4 bits to allow easy expansion and clear state distinction
typedef enum logic [3:0] {
    ST_A    = 4'd0,  // Reset state, hold here while resetn=0
    ST_F_ON = 4'd1,  // f=1 for one cycle after resetn released
    ST_SEQ1 = 4'd2,  // Waiting for first bit '1' in sequence x=1
    ST_SEQ2 = 4'd3,  // Waiting for second bit '0' in sequence x=0
    ST_SEQ3 = 4'd4,  // Waiting for third bit '1' in sequence x=1
    ST_G_ON_WAIT_Y_0 = 4'd5, // g=1, monitoring y (1st cycle)
    ST_G_ON_WAIT_Y_1 = 4'd6, // g=1, monitoring y (2nd cycle)
    ST_G_SUCCESS      = 4'd7, // g=1 forever (y=1 detected within 2 cycles)
    ST_G_FAIL         = 4'd8  // g=0 forever (y not detected)
} state_t;

state_t state, next_state;

// Synchronous state register
always_ff @(posedge clk) begin
    if (!resetn)
        state <= ST_A;
    else
        state <= next_state;
end

// Next-state logic
always_comb begin
    // Default stay in current state
    next_state = state;

    case (state)
        // While resetn asserted low, stay in reset
        ST_A: begin
            if (resetn)
                next_state = ST_F_ON;  // After resetn released, next cycle f=1
            else
                next_state = ST_A;
        end

        ST_F_ON: begin
            // f=1 for exactly one cycle, then start sequence detection
            next_state = ST_SEQ1;
        end

        // Sequence detection: 1,0,1 on x over 3 consecutive cycles
        ST_SEQ1: begin
            if (x == 1'b1)
                next_state = ST_SEQ2; // got first '1'
            else
                next_state = ST_SEQ1; // keep waiting
        end

        ST_SEQ2: begin
            if (x == 1'b0)
                next_state = ST_SEQ3; // got second '0'
            else if (x == 1'b1)
                next_state = ST_SEQ2; // stay, waiting for 0 after a 1
            else
                next_state = ST_SEQ1; // restart pattern (should not happen, x 1-bit)
        end

        ST_SEQ3: begin
            if (x == 1'b1)
                next_state = ST_G_ON_WAIT_Y_0; // sequence complete, start monitoring y
            else if (x == 1'b0)
                next_state = ST_SEQ1; // restart pattern if not matching
            else
                next_state = ST_SEQ1; // restart pattern defensively
        end

        // Monitor y input for up to 2 cycles while g=1
        ST_G_ON_WAIT_Y_0: begin
            // On first cycle monitoring y
            if (y == 1'b1)
                next_state = ST_G_SUCCESS;
            else
                next_state = ST_G_ON_WAIT_Y_1; // go to 2nd cycle monitoring
        end

        ST_G_ON_WAIT_Y_1: begin
            // Second and last cycle to see if y=1
            if (y == 1'b1)
                next_state = ST_G_SUCCESS;
            else
                next_state = ST_G_FAIL;
        end

        // Permanent states after success or failure
        ST_G_SUCCESS: next_state = ST_G_SUCCESS;
        ST_G_FAIL:    next_state = ST_G_FAIL;

        default: next_state = ST_A;
    endcase
end

// Output logic: purely combinational based on current state (Moore machine)
assign f = (state == ST_F_ON);
assign g = (state == ST_G_ON_WAIT_Y_0) ||
           (state == ST_G_ON_WAIT_Y_1)  ||
           (state == ST_G_SUCCESS);

endmodule