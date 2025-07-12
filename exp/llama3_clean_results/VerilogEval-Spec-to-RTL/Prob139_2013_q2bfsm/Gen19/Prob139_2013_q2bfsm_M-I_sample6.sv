module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // 0: Reset, 1: PostReset, 2: XSeqDetection, 3: YMonitor, 4: G1, 5: G0
reg [1:0] xSeqCounter; // Counter for x sequence detection
reg [1:0] yMonitorCounter; // Counter for monitoring y

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0;
        xSeqCounter <= 0;
        yMonitorCounter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // Reset State
                state <= 1; // Move to PostReset state after reset is de-asserted
            end
            1: begin // PostReset State
                f <= 1; // Set f to 1 for one clock cycle
                state <= 2; // Move to XSeqDetection state
            end
            2: begin // XSeqDetection State
                if (xSeqCounter == 0) begin
                    if (x) xSeqCounter <= 1;
                end else if (xSeqCounter == 1) begin
                    if (!x) xSeqCounter <= 2;
                    else xSeqCounter <= 1;
                end else if (xSeqCounter == 2) begin
                    if (x) begin
                        state <= 3; // Move to YMonitor state after detecting x sequence
                        xSeqCounter <= 0;
                    end else xSeqCounter <= 0;
                end
                f <= 0; // Ensure f is 0 after the initial pulse
            end
            3: begin // YMonitor State
                if (yMonitorCounter == 0) begin
                    yMonitorCounter <= 1;
                    if (y) begin
                        state <= 4; // Move to G1 state if y is 1
                        g <= 1;
                    end
                end else if (yMonitorCounter == 1) begin
                    if (y) begin
                        state <= 4; // Move to G1 state if y is 1
                        g <= 1;
                    end else begin
                        state <= 5; // Move to G0 state if y is not 1 within two clock cycles
                        g <= 0;
                    end
                    yMonitorCounter <= 0;
                end
            end
            4, 5: begin // Final States
                // No state transition needed; g is already set
            end
        endcase
    end
end

endmodule