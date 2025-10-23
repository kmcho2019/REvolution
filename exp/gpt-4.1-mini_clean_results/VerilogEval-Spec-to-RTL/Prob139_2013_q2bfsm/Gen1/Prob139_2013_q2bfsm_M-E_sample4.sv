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
localparam S_RESET     = 3'd0;
localparam S_F_PULSE   = 3'd1;
localparam S_WAIT_G    = 3'd2;
localparam S_MONITOR_Y = 3'd3;
localparam S_G0_PERM   = 3'd4;

reg [2:0] state, next_state;
reg [1:0] y_count; // to count up to 2 clock cycles monitoring y

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn) begin
        state   <= S_RESET;
        y_count <= 2'd0;
    end else begin
        state <= next_state;
        // Increment y_count only in S_MONITOR_Y state
        if (state == S_MONITOR_Y)
            y_count <= y_count + 2'd1;
        else
            y_count <= 2'd0;
    end
end

// Next state combinational logic
always @(*) begin
    next_state = state;
    case(state)
        S_RESET: begin
            if (resetn)
                next_state = S_F_PULSE;
            else
                next_state = S_RESET;
        end
        S_F_PULSE: begin
            // Output f=1 for one cycle, then proceed to wait for pattern detection
            next_state = S_WAIT_G;
        end
        S_WAIT_G: begin
            // Wait here until pattern 101 detected on x (pulse from seqdet)
            if (detected_pulse)
                next_state = S_MONITOR_Y; // after outputting g=1 for one cycle
            else
                next_state = S_WAIT_G;
        end
        S_MONITOR_Y: begin
            // Maintain g=1, monitor y for max 2 cycles since entry to this state
            // If y=1 within two cycles, stay here forever with g=1
            if (y == 1'b1)
                next_state = S_MONITOR_Y; // stay forever with g=1
            else if (y_count == 2'd2)
                next_state = S_G0_PERM; // time exceeded, set g=0 permanently
            else
                next_state = S_MONITOR_Y; // keep monitoring
        end
        S_G0_PERM: begin
            // g=0 forever until reset
            next_state = S_G0_PERM;
        end
        default: next_state = S_RESET;
    endcase
end

// Output logic
always @(*) begin
    f = 1'b0;
    g = 1'b0;
    case(state)
        S_RESET: begin
            f = 1'b0;
            g = 1'b0;
        end
        S_F_PULSE: begin
            f = 1'b1;  // f=1 for one cycle after reset release
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
    // Wait for first 1, then 0, then 1
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
                    sd_next_state = SD_S1; // stay waiting for 0
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