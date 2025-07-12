module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding with localparam (no SystemVerilog enums for compatibility)
    localparam S_A    = 3'd0; // Reset state
    localparam S_B    = 3'd1; // f=1 for one cycle after reset release
    localparam S_SEQ0 = 3'd2; // Wait for x=1 to start sequence
    localparam S_SEQ1 = 3'd3; // Wait for x=0
    localparam S_SEQ2 = 3'd4; // Wait for x=1 to complete sequence 1,0,1
    localparam S_MON  = 3'd5; // g=1, monitor y input up to 2 cycles
    localparam S_G1   = 3'd6; // g=1 permanently
    localparam S_G0   = 3'd7; // g=0 permanently

    reg [2:0] state, next_state;
    reg [1:0] mon_cnt, next_mon_cnt; // 2-bit counter for monitoring y

    // Sequential logic: state and mon_cnt update on posedge clk
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= S_A;
            mon_cnt <= 2'd0;
        end else begin
            state   <= next_state;
            mon_cnt <= next_mon_cnt;
        end
    end

    // Combinational logic for next state and mon_cnt
    always @(*) begin
        next_state   = state;
        next_mon_cnt = mon_cnt;

        case(state)
            S_A: begin
                // Stay in reset state while resetn=0
                if (resetn)
                    next_state = S_B;
                else
                    next_state = S_A;
                next_mon_cnt = 2'd0;
            end

            S_B: begin
                // f=1 for exactly one cycle after reset release
                next_state   = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_SEQ0: begin
                // Wait for x=1 to start sequence
                if (x)
                    next_state = S_SEQ1;
                else
                    next_state = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_SEQ1: begin
                // Wait for x=0; if x=1 here, could be start of new sequence, so stay or go back to S_SEQ1 accordingly
                if (!x)
                    next_state = S_SEQ2;
                else
                    // x=1 received again, restart sequence detection from S_SEQ1
                    next_state = S_SEQ1;
                next_mon_cnt = 2'd0;
            end

            S_SEQ2: begin
                // Wait for x=1 to complete sequence 1,0,1
                if (x)
                    next_state = S_MON;
                else if (x == 1'b0)
                    // If failed to get x=1, but x=0 received, restart sequence detection:
                    // since x=0 cannot start sequence, go to S_SEQ0
                    next_state = S_SEQ0;
                else
                    // Defensive: stay in S_SEQ2 (should not happen)
                    next_state = S_SEQ2;
                next_mon_cnt = 2'd0;
            end

            S_MON: begin
                // Monitor y input for up to 2 cycles with g=1

                if (y) begin
                    // y=1 detected within monitoring window -> permanent g=1
                    next_state   = S_G1;
                    next_mon_cnt = 2'd0;
                end else if (mon_cnt == 2'd1) begin
                    // After two cycles (count 0 and 1), no y=1 -> permanent g=0
                    next_state   = S_G0;
                    next_mon_cnt = 2'd0;
                end else begin
                    // Continue monitoring, increment mon_cnt
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
                // Defensive default to reset state
                next_state   = S_A;
                next_mon_cnt = 2'd0;
            end
        endcase
    end

    // Output logic: purely combinational, Moore FSM style
    always @(*) begin
        case(state)
            S_B: begin
                // One cycle pulse on f after reset release
                f = 1'b1;
                g = 1'b0;
            end

            S_MON,
            S_G1: begin
                // g=1 while monitoring or permanently in g=1 state
                f = 1'b0;
                g = 1'b1;
            end

            default: begin
                // Other states: outputs zero
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule