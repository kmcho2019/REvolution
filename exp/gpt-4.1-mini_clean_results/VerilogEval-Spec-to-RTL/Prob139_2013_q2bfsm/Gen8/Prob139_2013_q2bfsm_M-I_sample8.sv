module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (4 bits for clarity)
    localparam S_A      = 4'd0; // Reset state: hold here while resetn=0
    localparam S_WAIT   = 4'd1; // Wait one cycle after resetn=1 before f=1
    localparam S_B      = 4'd2; // f=1 one cycle pulse
    localparam S_SEQ0   = 4'd3; // Wait for x=1 (pattern start)
    localparam S_SEQ1   = 4'd4; // Matched '1', wait for '0'
    localparam S_SEQ2   = 4'd5; // Matched '1 0', wait for '1'
    localparam S_MON    = 4'd6; // g=1, monitor y for up to 2 cycles
    localparam S_G1     = 4'd7; // g=1 permanently
    localparam S_G0     = 4'd8; // g=0 permanently

    reg [3:0] state, next_state;
    reg [1:0] mon_cnt, next_mon_cnt;

    // Sequential logic: state and mon_cnt update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= S_A;
            mon_cnt <= 2'd0;
        end else begin
            state   <= next_state;
            mon_cnt <= next_mon_cnt;
        end
    end

    // Next state and counter logic
    always @(*) begin
        next_state   = state;
        next_mon_cnt = mon_cnt;

        case(state)
            S_A: begin
                // Stay in reset while resetn=0
                if (resetn)
                    next_state   = S_WAIT;  // Wait one cycle before f=1
                else begin
                    next_state   = S_A;
                    next_mon_cnt = 2'd0;
                end
            end

            S_WAIT: begin
                // One cycle wait after reset release
                next_state   = S_B;
                next_mon_cnt = 2'd0;
            end

            S_B: begin
                // f=1 pulse for one clock, then start pattern detection
                next_state   = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_SEQ0: begin
                // Wait for x=1 to start pattern
                if (x)
                    next_state = S_SEQ1;
                else
                    next_state = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_SEQ1: begin
                // Matched '1'; wait for x=0
                if (!x)
                    next_state = S_SEQ2;  // matched '1 0'
                else
                    next_state = S_SEQ1;  // restart pattern detection with '1'
                next_mon_cnt = 2'd0;
            end

            S_SEQ2: begin
                // Matched '1 0'; wait for x=1 to complete pattern
                if (x)
                    next_state = S_MON;
                else
                    next_state = S_SEQ0;  // restart detection
                next_mon_cnt = 2'd0;
            end

            S_MON: begin
                // g=1 while monitoring y for at most two cycles
                if (y) begin
                    // y=1 detected within 2 cycles: hold g=1 forever
                    next_state   = S_G1;
                    next_mon_cnt = 2'd0;
                end else if (mon_cnt == 2'd2) begin
                    // After 2 cycles y not detected: hold g=0 forever
                    next_state   = S_G0;
                    next_mon_cnt = 2'd0;
                end else begin
                    // Continue monitoring, increment counter
                    next_state   = S_MON;
                    next_mon_cnt = mon_cnt + 1'b1;
                end
            end

            S_G1: begin
                // Hold g=1 permanently
                next_state   = S_G1;
                next_mon_cnt = 2'd0;
            end

            S_G0: begin
                // Hold g=0 permanently
                next_state   = S_G0;
                next_mon_cnt = 2'd0;
            end

            default: begin
                next_state   = S_A;
                next_mon_cnt = 2'd0;
            end
        endcase
    end

    // Moore output logic (based on current state)
    always @(*) begin
        f = 1'b0;
        g = 1'b0;

        case(state)
            S_B: begin
                f = 1'b1;
                g = 1'b0;
            end

            S_MON,
            S_G1: begin
                f = 1'b0;
                g = 1'b1;
            end

            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule