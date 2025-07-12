module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] xSeqCounter;
reg [1:0] yMonitorCounter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0;
        xSeqCounter <= 0;
        yMonitorCounter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // Initialization and XSeqDetection
                if (xSeqCounter == 0) begin
                    if (x) xSeqCounter <= 1;
                end else if (xSeqCounter == 1) begin
                    if (!x) xSeqCounter <= 2;
                    else xSeqCounter <= 1;
                end else if (xSeqCounter == 2) begin
                    if (x) begin
                        state <= 1;
                        xSeqCounter <= 0;
                        f <= 1;
                    end else xSeqCounter <= 0;
                end
            end
            1: begin // YMonitor
                if (yMonitorCounter == 0) begin
                    yMonitorCounter <= 1;
                    if (y) begin
                        state <= 2;
                        g <= 1;
                    end
                end else if (yMonitorCounter == 1) begin
                    if (y) begin
                        state <= 2;
                        g <= 1;
                    end else begin
                        state <= 3;
                        g <= 0;
                    end
                end
            end
            2: begin // FinalStateG1
                g <= 1;
            end
            3: begin // FinalStateG0
                g <= 0;
            end
        endcase
        if (state!= 0) f <= 0;
    end
end

endmodule