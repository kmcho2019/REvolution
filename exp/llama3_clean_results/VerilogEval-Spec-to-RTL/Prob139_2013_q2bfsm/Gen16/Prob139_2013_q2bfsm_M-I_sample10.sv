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
    XSeq1,
    XSeq2,
    XSeq3,
    YMonitor1,
    YMonitor2,
    FinalStateG1,
    FinalStateG0
} state, nextState;

// Registers for state and next state
always @(posedge clk) begin
    if (!resetn) begin
        state <= Initialization;
        f <= 0;
        g <= 0;
    end else begin
        state <= nextState;
        // Reset f after initialization
        if (state == Initialization) begin
            f <= 1;
        end else begin
            f <= 0;
        end
        // Update g based on state
        case (state)
            FinalStateG1: g <= 1;
            FinalStateG0: g <= 0;
            default: g <= 0;
        endcase
    end
end

// Combinational logic to determine next state
always @(*) begin
    case (state)
        Initialization: nextState = x ? XSeq1 : Initialization;
        XSeq1: nextState = x ? XSeq1 : XSeq2;
        XSeq2: nextState = x ? XSeq3 : XSeq1;
        XSeq3: nextState = x ? YMonitor1 : XSeq1;
        YMonitor1: nextState = y ? FinalStateG1 : YMonitor2;
        YMonitor2: nextState = y ? FinalStateG1 : FinalStateG0;
        FinalStateG1, FinalStateG0: nextState = state; // Stay in the same state
    endcase
end

endmodule