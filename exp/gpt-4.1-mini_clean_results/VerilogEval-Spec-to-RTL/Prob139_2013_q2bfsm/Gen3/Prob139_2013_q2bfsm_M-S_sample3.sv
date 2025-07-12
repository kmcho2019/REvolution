module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        S_A      = 3'd0, // Reset state
        S_B      = 3'd1, // f=1 one cycle after reset release
        S_SEQ0   = 3'd2, // Wait for x=1 start seq
        S_SEQ1   = 3'd3, // Wait for x=0
        S_SEQ2   = 3'd4, // Wait for x=1, seq done -> monitor y
        S_MON    = 3'd5, // g=1, monitor y for 2 cycles
        S_G1     = 3'd6, // g=1 permanently
        S_G0     = 3'd7; // g=0 permanently

    reg [2:0] state, next_state;
    reg [1:0] mon_cnt; // Counter for y monitoring cycles (0..1)

    // Sequential: state, outputs, counter
    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_A;
            f <= 1'b0;
            g <= 1'b0;
            mon_cnt <= 2'd0;
        end else begin
            state <= next_state;

            // Outputs depend on current state
            case (state)
                S_A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    mon_cnt <= 2'd0;
                end

                S_B: begin
                    f <= 1'b1; // single cycle pulse after reset release
                    g <= 1'b0;
                    mon_cnt <= 2'd0;
                end

                S_SEQ0, S_SEQ1, S_SEQ2: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    mon_cnt <= 2'd0;
                end

                S_MON: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    mon_cnt <= mon_cnt + 1'b1;
                end

                S_G1: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    // hold mon_cnt stable
                    mon_cnt <= mon_cnt;
                end

                S_G0: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    mon_cnt <= mon_cnt;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    mon_cnt <= 2'd0;
                end
            endcase
        end
    end

    // Combinational: next state logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
            S_A: begin
                if (resetn)
                    next_state = S_B;
                else
                    next_state = S_A;
            end

            S_B: begin
                // One cycle pulse done, start sequence detection
                next_state = S_SEQ0;
            end

            S_SEQ0: begin
                // Wait for x=1 to start seq
                if (x)
                    next_state = S_SEQ1;
                else
                    next_state = S_SEQ0;
            end

            S_SEQ1: begin
                // Wait for x=0
                if (!x)
                    next_state = S_SEQ2;
                else
                    next_state = S_SEQ1; // wait until 0
            end

            S_SEQ2: begin
                // Wait for x=1
                if (x)
                    next_state = S_MON; // sequence detected
                else
                    next_state = S_SEQ0; // restart sequence detection
            end

            S_MON: begin
                // Monitor y for up to 2 cycles
                if (y)
                    next_state = S_G1; // detected y=1, hold g=1
                else if (mon_cnt == 2'd1)
                    next_state = S_G0; // after 2 cycles, no y=1, g=0 permanently
                else
                    next_state = S_MON; // keep monitoring
            end

            S_G1: begin
                // Hold g=1 until reset
                next_state = S_G1;
            end

            S_G0: begin
                // Hold g=0 until reset
                next_state = S_G0;
            end

            default: begin
                next_state = S_A;
            end
        endcase
    end

endmodule