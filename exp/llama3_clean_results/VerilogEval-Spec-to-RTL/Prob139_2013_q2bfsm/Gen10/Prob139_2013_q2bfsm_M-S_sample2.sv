module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [2:0] {
    RESET,
    INIT,
    SEQ_DET,
    WAIT_Y,
    G_SET,
    G_CLEAR
} state;

// Counter for sequence detection
reg [1:0] seq_count;

// Timer for waiting for y
reg [1:0] y_timer;

// Flag to track sequence
reg seq_detected;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        seq_count <= 0;
        y_timer <= 0;
        seq_detected <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            RESET: begin
                state <= INIT;
            end
            INIT: begin
                f <= 1;
                state <= SEQ_DET;
                seq_count <= 0;
                seq_detected <= 0;
            end
            SEQ_DET: begin
                case (seq_count)
                    0: begin
                        if (x) begin
                            seq_count <= 1;
                        end
                    end
                    1: begin
                        if (!x) begin
                            seq_count <= 2;
                        end
                    end
                    2: begin
                        if (x) begin
                            seq_detected <= 1;
                            state <= WAIT_Y;
                            y_timer <= 0;
                        end
                    end
                endcase
            end
            WAIT_Y: begin
                if (y) begin
                    state <= G_SET;
                end else if (y_timer < 2) begin
                    y_timer <= y_timer + 1;
                end else begin
                    state <= G_CLEAR;
                end
            end
            G_SET: begin
                g <= 1;
            end
            G_CLEAR: begin
                g <= 0;
            end
            default: begin
                state <= RESET;
            end
        endcase
        // Reset f after one clock cycle
        if (state != INIT) begin
            f <= 0;
        end
    end
end

endmodule