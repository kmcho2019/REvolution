module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States for the FSM
enum logic [2:0] {IDLE, SET_F, SEQ_DET, WAIT_Y, G_SET, G_CLEAR} state;

// Counter for sequence detection
reg [1:0] seq_count;

// Counter for waiting for y
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        seq_count <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (!resetn) begin
                    state <= IDLE;
                end else begin
                    state <= SET_F;
                    f <= 1;
                end
            end
            SET_F: begin
                state <= SEQ_DET;
                f <= 0;
            end
            SEQ_DET: begin
                if (x) begin
                    seq_count <= seq_count + 1;
                    if (seq_count == 3) begin
                        state <= WAIT_Y;
                        seq_count <= 0;
                    end
                end else begin
                    seq_count <= 0;
                end
            end
            WAIT_Y: begin
                if (y) begin
                    state <= G_SET;
                    y_count <= 0;
                end else if (y_count < 2) begin
                    y_count <= y_count + 1;
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
        endcase
    end
end

endmodule