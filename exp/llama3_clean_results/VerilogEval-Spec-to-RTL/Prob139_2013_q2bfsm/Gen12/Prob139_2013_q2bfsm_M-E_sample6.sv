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
    SequenceDetection,
    YMonitoring,
    FinalState
} state;

// Define sub-states for sequence detection
enum logic [1:0] {
    SeqStart,
    SeqMid,
    SeqEnd
} seq_state;

// Define sub-states for y monitoring
enum logic [1:0] {
    YWait0,
    YWait1
} y_state;

reg [1:0] seq_counter; // Counter for sequence detection
reg [1:0] y_counter; // Counter for y monitoring

always @(posedge clk) begin
    if (!resetn) begin
        state <= Initialization;
        seq_state <= SeqStart;
        y_state <= YWait0;
        seq_counter <= 0;
        y_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            Initialization: begin
                f <= 1;
                state <= SequenceDetection;
            end
            SequenceDetection: begin
                case (seq_state)
                    SeqStart: begin
                        if (x) begin
                            seq_state <= SeqMid;
                            seq_counter <= 1;
                        end else begin
                            seq_counter <= 0;
                        end
                    end
                    SeqMid: begin
                        if (!x) begin
                            seq_state <= SeqEnd;
                            seq_counter <= 2;
                        end else begin
                            seq_counter <= 0;
                            seq_state <= SeqStart;
                        end
                    end
                    SeqEnd: begin
                        if (x) begin
                            state <= YMonitoring;
                            seq_state <= SeqStart;
                            seq_counter <= 0;
                            f <= 0; // Reset f after one cycle
                        end else begin
                            seq_counter <= 0;
                            seq_state <= SeqStart;
                        end
                    end
                endcase
            end
            YMonitoring: begin
                case (y_state)
                    YWait0: begin
                        if (y) begin
                            state <= FinalState;
                            g <= 1; // Set g to 1 permanently
                        end else begin
                            y_state <= YWait1;
                            y_counter <= 1;
                        end
                    end
                    YWait1: begin
                        if (y) begin
                            state <= FinalState;
                            g <= 1; // Set g to 1 permanently
                        end else begin
                            state <= FinalState;
                            g <= 0; // Set g to 0 permanently
                        end
                    end
                endcase
            end
            FinalState: begin
                // No action, g is already set
            end
        endcase
    end
end