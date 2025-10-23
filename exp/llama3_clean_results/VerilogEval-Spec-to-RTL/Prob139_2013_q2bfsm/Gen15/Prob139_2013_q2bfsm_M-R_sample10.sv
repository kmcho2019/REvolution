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
        if (state == FinalStateG1) begin
            g <= 1;
        end else if (state == FinalStateG0) begin
            g <= 0;
        end else if (state == YMonitor1 && y) begin
            g <= 1;
        end else if (state == YMonitor2 && !y) begin
            g <= 0;
        end
    end
end

// Combinational logic to determine next state
always @(*) begin
    case (state)
        Initialization: nextState = XSeq1;
        XSeq1: begin
            if (x) begin
                nextState = XSeq2;
            end else begin
                nextState = XSeq1;
            end
        end
        XSeq2: begin
            if (!x) begin
                nextState = XSeq3;
            end else begin
                nextState = XSeq1;
            end
        end
        XSeq3: begin
            if (x) begin
                nextState = YMonitor1;
            end else begin
                nextState = XSeq1;
            end
        end
        YMonitor1: begin
            if (y) begin
                nextState = FinalStateG1;
            end else begin
                nextState = YMonitor2;
            end
        end
        YMonitor2: begin
            if (y) begin
                nextState = FinalStateG1;
            end else begin
                nextState = FinalStateG0;
            end
        end
        FinalStateG1, FinalStateG0: begin
            nextState = state; // Stay in the same state
        end
    endcase
end

endmodule