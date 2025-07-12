module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the main states
enum logic [2:0] {
    Initialization,
    XSeqDetection,
    YMonitor,
    FinalStateG1,
    FinalStateG0
} state, nextState;

// Registers for state
always @(posedge clk) begin
    if (!resetn) begin
        state <= Initialization;
        f <= 0;
        g <= 0;
    end else begin
        state <= nextState;
        if (state == Initialization) begin
            f <= 1;
        end else begin
            f <= 0;
        end
        case (state)
            FinalStateG1: g <= 1;
            FinalStateG0: g <= 0;
            default: g <= 0;
        endcase
    end
end

// Counter for x sequence detection
reg [1:0] xSeqCounter;
always @(posedge clk) begin
    if (!resetn) begin
        xSeqCounter <= 0;
    end else if (state == XSeqDetection) begin
        case (xSeqCounter)
            0: if (x) xSeqCounter <= 1; else xSeqCounter <= 0;
            1: if (!x) xSeqCounter <= 2; else xSeqCounter <= 1;
            2: if (x) xSeqCounter <= 2; else xSeqCounter <= 0;
            default: xSeqCounter <= 0;
        endcase
    end else begin
        xSeqCounter <= 0;
    end
end

// Counter for y monitoring
reg [1:0] yMonitorCounter;
always @(posedge clk) begin
    if (!resetn) begin
        yMonitorCounter <= 0;
    end else if (state == YMonitor) begin
        if (y) begin
            yMonitorCounter <= 0;
            nextState <= FinalStateG1;
        end else begin
            if (yMonitorCounter < 2) begin
                yMonitorCounter <= yMonitorCounter + 1;
            end else begin
                nextState <= FinalStateG0;
            end
        end
    end else begin
        yMonitorCounter <= 0;
    end
end

// Combinational logic to determine next state
always @(*) begin
    case (state)
        Initialization: nextState = XSeqDetection;
        XSeqDetection: if (xSeqCounter == 2) nextState = YMonitor; else nextState = XSeqDetection;
        YMonitor: nextState = YMonitor;
        FinalStateG1, FinalStateG0: nextState = state; // Stay in the same state
    endcase
end

endmodule