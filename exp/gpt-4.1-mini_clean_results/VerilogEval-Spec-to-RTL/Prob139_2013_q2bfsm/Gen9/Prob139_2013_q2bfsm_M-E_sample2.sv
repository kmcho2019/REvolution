module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // One-hot state encoding for clarity and speed
    localparam [7:0]
        S_A       = 8'b0000_0001, // Reset / idle
        S_F_PULSE = 8'b0000_0010, // f=1 pulse one cycle
        S_X1      = 8'b0000_0100, // detected first '1' of pattern
        S_X10     = 8'b0000_1000, // detected '10'
        S_X101    = 8'b0001_0000, // detected full '101', assert g=1 start timer
        S_WAITY1  = 8'b0010_0000, // g=1, waiting cycle 1 for y=1
        S_WAITY2  = 8'b0100_0000, // g=1, waiting cycle 2 for y=1
        S_G1      = 8'b1000_0000, // permanent g=1
        S_G0      = 8'b0000_0000; // permanent g=0 (zero vector used only here)

    reg [7:0] state, next_state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_A;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs as Mealy style (depend on state and inputs)
            case (state)
                S_A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                S_F_PULSE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                S_X1, S_X10, S_X101: begin
                    f <= 1'b0;
                    g <= (state == S_X101) ? 1'b1 : 1'b0;
                end
                S_WAITY1, S_WAITY2: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                S_G1: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                S_G0: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            S_A: begin
                // Hold in reset state while resetn low, else start f pulse
                if (resetn)
                    next_state = S_F_PULSE;
                else
                    next_state = S_A;
            end

            S_F_PULSE: begin
                // One cycle pulse of f=1, then start pattern detection on x
                next_state = x ? S_X1 : S_F_PULSE; 
                // If x=1 go to S_X1 else remain in S_F_PULSE
                // But problem states after f pulse we begin monitoring x, so if x=0 wait for first '1' of pattern
                if (~x)
                    next_state = S_F_PULSE; // hold here until x=1 to start pattern detection
                else
                    next_state = S_X1;
            end

            S_X1: begin
                // After first '1', expect '0' on next x
                if (~x)
                    next_state = S_X10;
                else
                    next_state = S_X1; // keep waiting for '0', pattern can't progress
            end

            S_X10: begin
                // After '10', expect '1' on next x
                if (x)
                    next_state = S_X101; // full pattern detected
                else
                    next_state = S_F_PULSE; 
                    // If mismatch here, restart pattern detection: 
                    // we could be getting first '1' of next pattern?
                    // But more robust is to restart from S_F_PULSE (monitoring start)
            end

            S_X101: begin
                // Detected 101, g=1 asserted this cycle
                // Start monitoring y next cycles for up to 2 cycles
                next_state = S_WAITY1;
            end

            S_WAITY1: begin
                // g=1, waiting 1st cycle for y=1
                if (y)
                    next_state = S_G1;    // y detected, hold g=1 forever
                else
                    next_state = S_WAITY2; // continue waiting
            end

            S_WAITY2: begin
                // g=1, waiting 2nd cycle for y=1
                if (y)
                    next_state = S_G1;    // y detected, hold g=1 forever
                else
                    next_state = S_G0;    // y not detected in time, g=0 forever
            end

            S_G1: begin
                // Hold g=1 until reset
                if (!resetn)
                    next_state = S_A;
                else
                    next_state = S_G1;
            end

            S_G0: begin
                // Hold g=0 until reset
                if (!resetn)
                    next_state = S_A;
                else
                    next_state = S_G0;
            end

            default: next_state = S_A;
        endcase
    end

endmodule