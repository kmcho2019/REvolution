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
} state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= Initialization;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            Initialization: begin
                f <= 1;
                state <= XSeq1;
            end
            XSeq1: begin
                if (x) begin
                    state <= XSeq2;
                end else begin
                    state <= XSeq1;
                end
                f <= 0;
            end
            XSeq2: begin
                if (!x) begin
                    state <= XSeq3;
                end else begin
                    state <= XSeq1;
                end
            end
            XSeq3: begin
                if (x) begin
                    state <= YMonitor1;
                end else begin
                    state <= XSeq1;
                end
            end
            YMonitor1: begin
                if (y) begin
                    state <= FinalStateG1;
                    g <= 1;
                end else begin
                    state <= YMonitor2;
                end
            end
            YMonitor2: begin
                if (y) begin
                    state <= FinalStateG1;
                    g <= 1;
                end else begin
                    state <= FinalStateG0;
                    g <= 0;
                end
            end
            FinalStateG1: begin
                g <= 1;
            end
            FinalStateG0: begin
                g <= 0;
            end
        endcase
    end
end

endmodule