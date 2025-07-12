module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (3 bits)
    localparam S_A      = 3'd0; // Reset state
    localparam S_B      = 3'd1; // f=1 one cycle after reset release
    localparam S_SEQ0   = 3'd2; // Waiting for x=1 (pattern start)
    localparam S_SEQ1   = 3'd3; // Matched '1', waiting for '0'
    localparam S_SEQ2   = 3'd4; // Matched '1 0', waiting for '1'
    localparam S_MON    = 3'd5; // g=1, monitoring y for up to 2 cycles
    localparam S_G1     = 3'd6; // g=1 permanently
    localparam S_G0     = 3'd7; // g=0 permanently

    reg [2:0] state, next_state;
    reg [1:0] mon_cnt, next_mon_cnt;

    // Sequential block: state and counter update
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
                // Hold in reset state while resetn=0
                if (resetn) begin
                    next_state   = S_B; // move to f=1 pulse
                    next_mon_cnt = 2'd0;
                end else begin
                    next_state   = S_A;
                    next_mon_cnt = 2'd0;
                end
            end

            S_B: begin
                // One-cycle f pulse, then start sequence detection
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
                // Matched '1'; now wait for x=0
                if (!x)
                    next_state = S_SEQ2;   // matched '1 0'
                else
                    next_state = S_SEQ1;   // x=1, pattern restarts with first bit matched again
                next_mon_cnt = 2'd0;
            end

            S_SEQ2: begin
                // Matched '1 0'; wait for x=1 to complete pattern
                if (x)
                    next_state = S_MON;    // pattern complete
                else
                    next_state = S_SEQ0;   // pattern broken, restart detection
                next_mon_cnt = 2'd0;
            end

            S_MON: begin
                // Monitor y up to 2 cycles, g=1 during this state
                if (y) begin
                    // y detected in monitoring window, hold g=1 permanently
                    next_state   = S_G1;
                    next_mon_cnt = 2'd0;
                end else if (mon_cnt == 2'd1) begin
                    // Two cycles elapsed without y=1, hold g=0 permanently
                    next_state   = S_G0;
                    next_mon_cnt = 2'd0;
                end else begin
                    // Continue monitoring, increment counter
                    next_state   = S_MON;
                    next_mon_cnt = mon_cnt + 1'b1;
                end
            end

            S_G1: begin
                // Hold g=1 permanently until reset
                next_state   = S_G1;
                next_mon_cnt = 2'd0;
            end

            S_G0: begin
                // Hold g=0 permanently until reset
                next_state   = S_G0;
                next_mon_cnt = 2'd0;
            end

            default: begin
                next_state   = S_A;
                next_mon_cnt = 2'd0;
            end
        endcase
    end

    // Moore output logic
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