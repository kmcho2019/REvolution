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
    YMonitor,
    GSet,
    GClear
} state, nextState;

reg [1:0] xSeqCounter;
reg [1:0] yMonitorCounter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= Initialization;
        f <= 0;
        g <= 0;
        xSeqCounter <= 0;
        yMonitorCounter <= 0;
    end else begin
        case (state)
            Initialization: begin
                f <= 1;
                nextState <= XSeqDetection;
            end
            XSeqDetection: begin
                case (xSeqCounter)
                    0: if (x) xSeqCounter <= 1; else xSeqCounter <= 0;
                    1: if (!x) xSeqCounter <= 2; else xSeqCounter <= 1;
                    2: if (x) xSeqCounter <= 2; else xSeqCounter <= 0;
                    default: xSeqCounter <= 0;
                endcase
                if (xSeqCounter == 2) begin
                    nextState <= YMonitor;
                    g <= 1;
                    yMonitorCounter <= 0;
                end else begin
                    nextState <= XSeqDetection;
                end
            end
            YMonitor: begin
                if (y) begin
                    nextState <= GSet;
                end else begin
                    yMonitorCounter <= yMonitorCounter + 1;
                    if (yMonitorCounter < 2) begin
                        nextState <= YMonitor;
                    end else begin
                        nextState <= GClear;
                    end
                end
            end
            GSet: begin
                g <= 1;
                nextState <= GSet;
            end
            GClear: begin
                g <= 0;
                nextState <= GClear;
            end
            default: begin
                nextState <= Initialization;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (!resetn) begin
        f <= 0;
    end else if (state == Initialization) begin
        f <= 1;
    end else begin
        f <= 0;
    end
end