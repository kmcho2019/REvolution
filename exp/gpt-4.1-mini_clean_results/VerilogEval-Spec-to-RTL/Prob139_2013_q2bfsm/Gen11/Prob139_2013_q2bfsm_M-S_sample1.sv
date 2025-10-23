module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [3:0] {
        STATE_A  = 4'd0, // reset: f=0,g=0
        STATE_B  = 4'd1, // f=1 pulse (1 cycle after reset deassert)
        STATE_C0 = 4'd2, // wait for x=1
        STATE_C1 = 4'd3, // got x=1, wait for x=0
        STATE_C2 = 4'd4, // got 1,0; wait for x=1
        STATE_D  = 4'd5, // g=1 pulse (1 cycle after pattern detect)
        STATE_E0 = 4'd6, // monitor y cycle 1 with g=1
        STATE_E1 = 4'd7, // monitor y cycle 2 with g=1
        STATE_F  = 4'd8, // permanent g=1
        STATE_G  = 4'd9  // permanent g=0
    } state_t;

    state_t state, next_state;

    // Sequential: update state on clk posedge with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Combinational: next state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (resetn)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end

            STATE_B: next_state = STATE_C0;

            STATE_C0: next_state = (x == 1'b1) ? STATE_C1 : STATE_C0;

            STATE_C1: next_state = (x == 1'b0) ? STATE_C2 : STATE_C1;

            STATE_C2: next_state = (x == 1'b1) ? STATE_D : STATE_C0;

            STATE_D: next_state = STATE_E0;

            STATE_E0: next_state = (y == 1'b1) ? STATE_F : STATE_E1;

            STATE_E1: next_state = (y == 1'b1) ? STATE_F : STATE_G;

            STATE_F: next_state = STATE_F;

            STATE_G: next_state = STATE_G;

            default: next_state = STATE_A;
        endcase
    end

    // Outputs depend only on current state (Moore outputs)
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;

        case(state)
            STATE_B: f = 1'b1; // f pulse
            STATE_D, STATE_E0, STATE_E1, STATE_F: g = 1'b1; // g asserted as required
            default: ; // f=0,g=0 otherwise
        endcase
    end

endmodule