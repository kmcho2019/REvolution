module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding using parameters for Verilog compatibility
    localparam S_A      = 3'd0; // Reset state
    localparam S_B      = 3'd1; // f=1 one cycle after reset release
    localparam S_SEQ0   = 3'd2; // Waiting for x=1 (start sequence)
    localparam S_SEQ1   = 3'd3; // Waiting for x=0
    localparam S_SEQ2   = 3'd4; // Waiting for x=1 (end sequence)
    localparam S_MON    = 3'd5; // g=1, monitor y input up to 2 cycles
    localparam S_G1     = 3'd6; // g=1 permanently
    localparam S_G0     = 3'd7; // g=0 permanently

    reg [2:0] state, next_state;
    reg [1:0] mon_cnt, next_mon_cnt; // Counter for up to 2 cycles monitoring y

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

    // Combinational logic: next state and mon_cnt
    always @(*) begin
        // Default to hold current state and counter
        next_state   = state;
        next_mon_cnt = mon_cnt;

        case(state)
            S_A: begin
                // Stay in reset state as long as resetn=0
                if (resetn) begin
                    next_state = S_B; // move to f=1 pulse state
                    next_mon_cnt = 2'd0;
                end else begin
                    next_state = S_A;
                    next_mon_cnt = 2'd0;
                end
            end

            S_B: begin
                // After asserting f=1 for one clock cycle, move to sequence detection
                next_state   = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_SEQ0: begin
                // Wait for x=1 to start sequence
                if (x) begin
                    next_state = S_SEQ1;
                end else begin
                    next_state = S_SEQ0;
                end
                next_mon_cnt = 2'd0;
            end

            S_SEQ1: begin
                // Wait for x=0
                if (!x) begin
                    next_state = S_SEQ2;
                end else begin
                    // If x=1 here, restart detection to S_SEQ0 (since x=1 can start new sequence)
                    next_state = S_SEQ0;
                end
                next_mon_cnt = 2'd0;
            end

            S_SEQ2: begin
                // Wait for x=1 to complete pattern 1,0,1
                if (x) begin
                    next_state = S_MON; // Pattern detected, start monitoring y
                    next_mon_cnt = 2'd0;
                end else begin
                    // If x=0 at S_SEQ2, restart detection at S_SEQ0
                    next_state = S_SEQ0;
                    next_mon_cnt = 2'd0;
                end
            end

            S_MON: begin
                // Monitor y for at most 2 cycles, g=1 during monitoring
                if (y) begin
                    // y=1 detected within monitoring window
                    next_state   = S_G1;
                    next_mon_cnt = 2'd0;
                end else if (mon_cnt == 2'd1) begin
                    // After two cycles (count 0 and 1), if no y=1, g=0 permanently
                    next_state   = S_G0;
                    next_mon_cnt = 2'd0;
                end else begin
                    // Continue monitoring and increment mon_cnt
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
                next_state   = S_A;
                next_mon_cnt = 2'd0;
            end
        endcase
    end

    // Output logic (Moore FSM): outputs depend only on current state
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;

        case(state)
            S_B: begin
                // One cycle pulse on f immediately after reset release
                f = 1'b1;
                g = 1'b0;
            end

            S_MON,
            S_G1: begin
                // g=1 while monitoring or permanently after y=1 detected
                f = 1'b0;
                g = 1'b1;
            end

            default: begin
                // f=0, g=0 in all other states
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule