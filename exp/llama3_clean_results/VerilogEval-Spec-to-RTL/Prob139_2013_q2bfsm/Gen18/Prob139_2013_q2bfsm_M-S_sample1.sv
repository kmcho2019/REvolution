module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the main states
enum logic [1:0] {
    Initialization,
    XSeqDetection,
    YMonitor
} state, nextState;

reg [2:0] xSeqCounter;
reg [1:0] yMonitorCounter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= Initialization;
        f <= 0;
        g <= 0;
        xSeqCounter <= 0;
        yMonitorCounter <= 0;
    end else begin
        state <= nextState;
        case (state)
            Initialization: begin
                f <= 1;
                g <= 0;
            end
            XSeqDetection: begin
                f <= 0;
                g <= 0;
            end
            YMonitor: begin
                f <= 0;
                if (y || yMonitorCounter > 1) begin
                    g <= 1;
                end else if (yMonitorCounter == 2) begin
                    g <= 0;
                end
            end
        endcase
        case (state)
            XSeqDetection: begin
                case (xSeqCounter)
                    0: if (x) xSeqCounter <= 1; else xSeqCounter <= 0;
                    1: if (!x) xSeqCounter <= 2; else xSeqCounter <= 1;
                    2: if (x) xSeqCounter <= 2; else xSeqCounter <= 0;
                    default: xSeqCounter <= 0;
                endcase
            end
            YMonitor: begin
                if (y) yMonitorCounter <= 0; else yMonitorCounter <= yMonitorCounter + 1;
            end
            default: begin
                xSeqCounter <= 0;
                yMonitorCounter <= 0;
            end
        endcase
    end
end

// Combinational logic to determine next state
always @(*) begin
    case (state)
        Initialization: nextState = XSeqDetection;
        XSeqDetection: if (xSeqCounter == 2) nextState = YMonitor; else nextState = XSeqDetection;
        YMonitor: if (yMonitorCounter == 2) nextState = YMonitor; else nextState = YMonitor;
    endcase
end

endmodule