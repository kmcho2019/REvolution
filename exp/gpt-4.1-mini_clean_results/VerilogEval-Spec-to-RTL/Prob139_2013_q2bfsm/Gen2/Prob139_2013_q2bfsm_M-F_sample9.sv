module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

// Sequence Detector for pattern 101 on input x
// Outputs detected_pulse: high for one clock cycle immediately after pattern matched
wire detected_pulse;

SequenceDetector101 seqdet (
    .clk(clk),
    .resetn(resetn),
    .x(x),
    .detected_pulse(detected_pulse)
);

// Main FSM states encoding
localparam S_RESET           = 3'd0; // wait in reset
localparam S_WAIT_AFTER_RESET= 3'd1; // wait one cycle after reset release before f=1
localparam S_F_PULSE         = 3'd2; // f=1 for one cycle
localparam S_WAIT_G          = 3'd3; // wait for detected_pulse from sequence detector
localparam S_MONITOR_Y       = 3'd4; // g=1, monitor y for up to 2 cycles
localparam S_G0_PERM         = 3'd5; // g=0 forever until reset

reg [2:0] state, next_state;
reg [1:0] y_count; // count number of cycles monitoring y

// State register and y_count with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn) begin
        state   <= S_RESET;
        y_count <= 2'd0;
    end else begin
        state <= next_state;

        // Manage y_count:
        // Reset to zero when leaving or entering S_MONITOR_Y
        if (state != S_MONITOR_Y)
            y_count <= 2'd0;
        else if (state == S_MONITOR_Y) begin
            // Increment y_count only if staying in S_MONITOR_Y next cycle
            if (next_state == S_MONITOR_Y)
                y_count <= y_count + 2'd1;
            else
                y_count <= y_count; // hold if leaving
        end
    end
end

// Next state combinational logic
always @(*) begin
    next_state = state;
    case(state)
        S_RESET: begin
            if (resetn)
                next_state = S_WAIT_AFTER_RESET;
            else
                next_state = S_RESET;
        end
        S_WAIT_AFTER_RESET: begin
            // wait one cycle after resetn=1 before asserting f=1
            next_state = S_F_PULSE;
        end
        S_F_PULSE: begin
            // f=1 for one cycle, then go to wait for pattern detection
            next_state = S_WAIT_G;
        end
        S_WAIT_G: begin
            if (detected_pulse)
                next_state = S_MONITOR_Y;
            else
                next_state = S_WAIT_G;
        end
        S_MONITOR_Y: begin
            // monitor y for up to two cycles since entry
            if (y == 1'b1)
                next_state = S_MONITOR_Y; // stay forever with g=1
            else if (y_count == 2'd2)
                next_state = S_G0_PERM;   // exceeded 2 cycles, set g=0 permanently
            else
                next_state = S_MONITOR_Y; // keep monitoring
        end
        S_G0_PERM: begin
            next_state = S_G0_PERM; // hold forever until reset
        end
        default: next_state = S_RESET;
    endcase
end

// Output logic (registered)
always @(*) begin
    f = 1'b0;
    g = 1'b0;
    case(state)
        S_RESET: begin
            f = 1'b0;
            g = 1'b0;
        end
        S_WAIT_AFTER_RESET: begin
            f = 1'b0;
            g = 1'b0;
        end
        S_F_PULSE: begin
            f = 1'b1;  // f=1 for one cycle
            g = 1'b0;
        end
        S_WAIT_G: begin
            f = 1'b0;
            g = 1'b0;
        end
        S_MONITOR_Y: begin
            f = 1'b0;
            g = 1'b1;
        end
        S_G0_PERM: begin
            f = 1'b0;
            g = 1'b0;
        end
        default: begin
            f = 1'b0;
            g = 1'b0;
        end
    endcase
end

endmodule


// Sequence detector module for pattern 101 on input x
// Synchronous reset active low
// Output detected_pulse goes high for one clock cycle immediately after pattern detected

module SequenceDetector101 (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    output reg  detected_pulse
);

    // States encoding
    localparam SD_S0 = 2'd0; // wait for first 1
    localparam SD_S1 = 2'd1; // got 1, wait for 0
    localparam SD_S2 = 2'd2; // got 10, wait for 1

    reg [1:0] sd_state, sd_next_state;

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            sd_state <= SD_S0;
        end else begin
            sd_state <= sd_next_state;
        end
    end

    // Next state logic and detected pulse generation (Mealy style)
    always @(*) begin
        detected_pulse = 1'b0;
        sd_next_state = sd_state;
        case (sd_state)
            SD_S0: begin
                if (x == 1'b1)
                    sd_next_state = SD_S1;
                else
                    sd_next_state = SD_S0;
            end
            SD_S1: begin
                if (x == 1'b0)
                    sd_next_state = SD_S2;
                else if (x == 1'b1)
                    sd_next_state = SD_S1;
                else
                    sd_next_state = SD_S1;
            end
            SD_S2: begin
                if (x == 1'b1) begin
                    sd_next_state = SD_S1; // partial overlap: pattern ends with '1'
                    detected_pulse = 1'b1;
                end else if (x == 1'b0) begin
                    sd_next_state = SD_S0; // fail, restart
                end else begin
                    sd_next_state = SD_S2;
                end
            end
            default: begin
                sd_next_state = SD_S0;
            end
        endcase
    end

endmodule