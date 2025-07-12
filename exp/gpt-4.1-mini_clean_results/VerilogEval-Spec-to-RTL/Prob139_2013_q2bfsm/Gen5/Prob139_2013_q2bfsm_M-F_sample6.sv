module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding with typedef enum (SystemVerilog style)
    typedef enum logic [2:0] {
        S_A      = 3'd0, // Reset state
        S_B      = 3'd1, // f=1 one cycle after reset release
        S_SEQ0   = 3'd2, // Wait for x=1 start sequence
        S_SEQ1   = 3'd3, // Wait for x=0
        S_SEQ2   = 3'd4, // Wait for x=1 (end of sequence)
        S_MON    = 3'd5, // g=1, monitor y input up to 2 cycles
        S_G1     = 3'd6, // g=1 permanently
        S_G0     = 3'd7  // g=0 permanently
    } state_t;

    state_t state, next_state;
    reg [1:0] mon_cnt, next_mon_cnt; // 2-bit counter to monitor y for up to 2 cycles

    // Sequential logic: state and counter update at posedge clk
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= S_A;
            mon_cnt <= 2'd0;
        end else begin
            state   <= next_state;
            mon_cnt <= next_mon_cnt;
        end
    end

    // Combinational logic: next state and mon_cnt generation
    always @(*) begin
        // Default assignments to hold current values
        next_state   = state;
        next_mon_cnt = mon_cnt;

        case(state)
            S_A: begin
                // Stay in reset state as long as resetn is low
                if (resetn)
                    next_state = S_B;
                else
                    next_state = S_A;
                next_mon_cnt = 2'd0;
            end

            S_B: begin
                // After asserting f=1 for one cycle, move to sequence detection start
                next_state   = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_SEQ0: begin
                // Wait for x=1
                if (x)
                    next_state = S_SEQ1;
                else
                    next_state = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_SEQ1: begin
                // Wait for x=0
                if (!x)
                    next_state = S_SEQ2;
                else
                    next_state = S_SEQ1;
                next_mon_cnt = 2'd0;
            end

            S_SEQ2: begin
                // Wait for x=1 to complete pattern 1,0,1
                if (x)
                    next_state = S_MON; // Sequence detected, start monitoring y
                else
                    next_state = S_SEQ0; // Restart pattern detection if wrong input
                next_mon_cnt = 2'd0;
            end

            S_MON: begin
                // Monitor y for up to two cycles while g=1

                if (y) begin
                    // If y=1 detected within monitoring window, hold g=1 permanently
                    next_state   = S_G1;
                    next_mon_cnt = 2'd0; // reset counter
                end else if (mon_cnt == 2'd1) begin
                    // After two cycles without y=1 (mon_cnt counts from 0, so 0 and 1 means 2 cycles)
                    // Transition to g=0 permanently
                    next_state   = S_G0;
                    next_mon_cnt = 2'd0;
                end else begin
                    // Still monitoring: increment mon_cnt to track number of cycles elapsed
                    next_state   = S_MON;
                    next_mon_cnt = mon_cnt + 1'b1;
                end
            end

            S_G1: begin
                // Permanently hold g=1 until reset
                next_state   = S_G1;
                next_mon_cnt = 2'd0;
            end

            S_G0: begin
                // Permanently hold g=0 until reset
                next_state   = S_G0;
                next_mon_cnt = 2'd0;
            end

            default: begin
                // Defensive default: go to reset state
                next_state   = S_A;
                next_mon_cnt = 2'd0;
            end
        endcase
    end

    // Output logic: combinational, Moore FSM style (outputs depend on current state)
    always @(*) begin
        case(state)
            S_B: begin
                // One cycle pulse on f after reset release
                f = 1'b1;
                g = 1'b0;
            end

            S_MON,
            S_G1: begin
                // While monitoring y and in permanent g=1 state, output g=1
                f = 1'b0;
                g = 1'b1;
            end

            default: begin
                // All other states: outputs zero
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule