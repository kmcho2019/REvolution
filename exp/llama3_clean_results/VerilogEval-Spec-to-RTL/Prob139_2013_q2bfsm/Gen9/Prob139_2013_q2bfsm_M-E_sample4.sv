module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Main state machine
enum logic [1:0] {RESET, INIT, SEQ_DET, WAIT_Y, G_SET, G_CLEAR} main_state;

// Sequence detection sub-state machine
enum logic [1:0] {SEQ_IDLE, SEQ_1, SEQ_0, SEQ_1_DONE} seq_state;

// Waiting sub-state machine
enum logic [1:0] {WAIT_IDLE, WAIT_Y_TIMEOUT} wait_state;

// Counter for sequence detection
reg [1:0] seq_count;

// Timer for waiting for y
reg [1:0] y_timer;

always @ (posedge clk) begin
    if (!resetn) begin
        main_state <= RESET;
        seq_state <= SEQ_IDLE;
        wait_state <= WAIT_IDLE;
        seq_count <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (main_state)
            RESET: begin
                main_state <= INIT;
            end
            INIT: begin
                f <= 1;
                main_state <= SEQ_DET;
            end
            SEQ_DET: begin
                case (seq_state)
                    SEQ_IDLE: begin
                        if (x) begin
                            seq_state <= SEQ_1;
                            seq_count <= 1;
                        end
                    end
                    SEQ_1: begin
                        if (!x) begin
                            seq_state <= SEQ_0;
                            seq_count <= 2;
                        end
                    end
                    SEQ_0: begin
                        if (x) begin
                            seq_state <= SEQ_1_DONE;
                            seq_count <= 3;
                        end
                    end
                    SEQ_1_DONE: begin
                        main_state <= WAIT_Y;
                        wait_state <= WAIT_IDLE;
                        y_timer <= 0;
                    end
                endcase
            end
            WAIT_Y: begin
                case (wait_state)
                    WAIT_IDLE: begin
                        if (y) begin
                            main_state <= G_SET;
                        end else if (y_timer < 2) begin
                            y_timer <= y_timer + 1;
                        end else begin
                            main_state <= G_CLEAR;
                        end
                    end
                endcase
            end
            G_SET: begin
                g <= 1;
            end
            G_CLEAR: begin
                g <= 0;
            end
        endcase
    end
end

endmodule