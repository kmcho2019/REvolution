module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (one-hot for clarity)
    localparam S_RESET       = 6'b000001; // in reset
    localparam S_INIT        = 6'b000010; // 1 cycle wait after resetn deassert
    localparam S_F_PULSE     = 6'b000100; // assert f=1 for 1 cycle
    localparam S_WAIT_PAT    = 6'b001000; // wait for 101 pattern pulse
    localparam S_MONITOR_Y   = 6'b010000; // g=1, monitor y up to 2 cycles
    localparam S_G0_PERM     = 6'b100000; // g=0 forever until reset
    // We will also use S_G1_PERM for permanent g=1 state
    localparam S_G1_PERM     = 6'b100000; // reuse G0 bit and separate by another register
    // Because one-hot has only 6 bits, use 7 bits for separate permanent states:
    // To keep clarity, we split permanent g=1 and g=0 states by a separate bit variable
    
    // Use a separate reg to track whether in g=1 permanent or g=0 permanent:
    reg perm_g_state; // 0: none or not permanent, 1: g=1 permanent, 0: g=0 permanent
    
    reg [5:0] state, next_state;

    // Sequence detector for pattern 101 on x input
    wire pattern_pulse;
    SequenceDetector101 seqdet (
        .clk(clk),
        .resetn(resetn),
        .x(x),
        .detected_pulse(pattern_pulse)
    );

    // y counter for monitoring y up to 2 cycles
    reg [1:0] y_counter;

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_RESET;
            y_counter <= 2'd0;
            perm_g_state <= 1'b0; // no permanent g at reset
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Update y_counter only in MONITOR_Y state
            if (state == S_MONITOR_Y) begin
                // Increment y_counter each cycle we stay in MONITOR_Y
                // Reset to zero on first cycle entering MONITOR_Y (detected by state change)
                if (next_state == S_MONITOR_Y)
                    y_counter <= y_counter + 2'd1;
                else
                    y_counter <= y_counter; // hold if leaving MONITOR_Y
            end else begin
                y_counter <= 2'd0;
            end

            // Update permanent g state on transitions out of MONITOR_Y
            if (state == S_MONITOR_Y) begin
                if (y == 1'b1) begin
                    perm_g_state <= 1'b1; // permanent g=1
                end else if (y_counter == 2'd2) begin
                    perm_g_state <= 1'b0; // permanent g=0
                end
            end else if (next_state == S_RESET) begin
                // clear permanent state on reset
                perm_g_state <= 1'b0;
            end

            // Update outputs f and g based on state and perm_g_state
            case (next_state)
                S_RESET: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                S_INIT: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                S_F_PULSE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                S_WAIT_PAT: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                S_MONITOR_Y: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                default: begin
                    f <= 1'b0;
                    // In permanent g=1 or g=0 states
                    if (perm_g_state == 1'b1)
                        g <= 1'b1;
                    else
                        g <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state; // default hold
        case (state)
            S_RESET: begin
                if (resetn)
                    next_state = S_INIT; // wait one cycle after resetn deassertion
                else
                    next_state = S_RESET;
            end
            S_INIT: begin
                // after one cycle delay, pulse f=1
                next_state = S_F_PULSE;
            end
            S_F_PULSE: begin
                // f=1 pulse done, wait for pattern on x
                next_state = S_WAIT_PAT;
            end
            S_WAIT_PAT: begin
                if (pattern_pulse)
                    next_state = S_MONITOR_Y; // pattern detected, start monitor y
                else
                    next_state = S_WAIT_PAT;
            end
            S_MONITOR_Y: begin
                if (y == 1'b1) begin
                    // y=1 detected within allowed cycles, go permanent g=1
                    // Use permanent g=1 by holding in a stable state outside monitor
                    next_state = S_G1_PERM;
                end else if (y_counter == 2'd2) begin
                    // y not detected within 2 cycles, permanent g=0
                    next_state = S_G0_PERM;
                end else begin
                    next_state = S_MONITOR_Y;
                end
            end
            S_G0_PERM: begin
                // permanent g=0 until reset
                if (!resetn)
                    next_state = S_RESET;
                else
                    next_state = S_G0_PERM;
            end
            S_G1_PERM: begin
                // permanent g=1 until reset
                if (!resetn)
                    next_state = S_RESET;
                else
                    next_state = S_G1_PERM;
            end
            default: next_state = S_RESET;
        endcase
    end

endmodule


// SequenceDetector101: Detects pattern 101 on input x.
// Produces a one-clock-cycle pulse detected_pulse immediately after pattern detected.
// Implements a Moore FSM synchronized on clk, resetn active low.

module SequenceDetector101 (
    input wire clk,
    input wire resetn,
    input wire x,
    output reg detected_pulse
);

    // State encoding
    typedef enum logic [1:0] {
        SD_S0 = 2'd0, // initial wait for '1'
        SD_S1 = 2'd1, // detected '1', wait for '0'
        SD_S2 = 2'd2  // detected '10', wait for '1'
    } sd_state_t;

    sd_state_t state, next_state;

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= SD_S0;
            detected_pulse <= 1'b0;
        end else begin
            state <= next_state;
            // detected_pulse only asserted on state transition from SD_S2 with input x=1
            if (state == SD_S2 && x == 1'b1)
                detected_pulse <= 1'b1;
            else
                detected_pulse <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SD_S0: next_state = (x == 1'b1) ? SD_S1 : SD_S0;
            SD_S1: next_state = (x == 1'b0) ? SD_S2 : SD_S1;
            SD_S2: next_state = (x == 1'b1) ? SD_S1 : SD_S0;
            default: next_state = SD_S0;
        endcase
    end

endmodule