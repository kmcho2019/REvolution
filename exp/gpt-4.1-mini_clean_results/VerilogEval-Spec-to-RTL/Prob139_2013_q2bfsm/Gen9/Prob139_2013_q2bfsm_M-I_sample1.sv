module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (3 bits sufficient)
    typedef enum reg [2:0] {
        S_A      = 3'd0, // reset state
        S_WAIT   = 3'd1, // wait one cycle after reset release before f=1
        S_B      = 3'd2, // f=1 one cycle pulse
        S_SEQ0   = 3'd3, // wait for x=1 (pattern start)
        S_SEQ1   = 3'd4, // matched '1', wait for '0'
        S_SEQ2   = 3'd5, // matched '1 0', wait for '1'
        S_MON    = 3'd6, // g=1, monitor y for up to two cycles
        S_G1     = 3'd7, // g=1 permanently
        // Note: g=0 permanently state is implicitly when not in S_MON or S_G1 with g=0 output
        // For clarity and cleaner code, we define S_G0 explicitly:
        // But since all outputs are Moore, any non-listed state has g=0.
        S_G0     = 3'd0  // reuse S_A encoding for reset or g=0 permanent, equivalent behavior
    } state_t;

    reg [2:0] state, next_state;
    reg [1:0] mon_cnt, next_mon_cnt; // count up to 2

    // Sequential logic for state and mon_cnt, synchronous active low resetn
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= S_A;
            mon_cnt <= 2'd0;
        end else begin
            state   <= next_state;
            mon_cnt <= next_mon_cnt;
        end
    end

    // Next state and mon_cnt logic
    always @(*) begin
        next_state   = state;
        next_mon_cnt = mon_cnt;

        case(state)
            S_A: begin
                if (resetn)
                    next_state   = S_WAIT;  // move to wait one cycle after reset release
                else begin
                    next_state   = S_A;
                    next_mon_cnt = 2'd0;
                end
            end

            S_WAIT: begin
                // After one cycle wait, assert f=1
                next_state   = S_B;
                next_mon_cnt = 2'd0;
            end

            S_B: begin
                // f=1 one cycle pulse, then start pattern detection
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
                // Matched '1', wait for x=0
                if (!x)
                    next_state = S_SEQ2;  // matched '1 0'
                else
                    // If x=1 again, could be start of new pattern, stay here
                    next_state = S_SEQ1;
                next_mon_cnt = 2'd0;
            end

            S_SEQ2: begin
                // Matched '1 0', wait for x=1 to complete pattern
                if (x)
                    next_state = S_MON;
                else
                    next_state = S_SEQ0;  // restart detection
                next_mon_cnt = 2'd0;
            end

            S_MON: begin
                // g=1 while monitoring y for up to two cycles
                if (y) begin
                    // y=1 detected within two cycles: hold g=1 forever
                    next_state   = S_G1;
                    next_mon_cnt = 2'd0;
                end else if (mon_cnt == 2'd1) begin
                    // After two cycles (mon_cnt 0 and 1 counted), y not detected: g=0 permanently
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