module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States for the FSM
enum logic [1:0] {IDLE, SET_F, WAIT_Y, G_SET, G_CLEAR} state;

// Counter for waiting for y
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            IDLE: begin
                state <= SET_F;
                f <= 1;
            end
            SET_F: begin
                state <= IDLE;
                f <= 0;
                if (x) begin
                    state <= IDLE;
                end else begin
                    state <= IDLE;
                end
            end
            IDLE: begin
                if (x) begin
                    state <= IDLE;
                end else if (!x && state == IDLE) begin
                    state <= IDLE;
                end else if (x && state == IDLE) begin
                    state <= IDLE;
                end
                if (x) begin
                    state <= IDLE;
                end else begin
                    state <= IDLE;
                end
            end
            // sequence detection for x = 1, 0, 1
            IDLE: begin
                if (x) begin
                    state <= IDLE;
                end else if (!x && state == IDLE) begin
                    state <= IDLE;
                end else if (x && state == IDLE) begin
                    state <= IDLE;
                end
                if (x) begin
                    state <= IDLE;
                end else begin
                    state <= IDLE;
                end
            end
            IDLE: begin
                reg [1:0] seq_count;
                if (x) begin
                    seq_count <= seq_count + 1;
                    if (seq_count == 3) begin
                        state <= WAIT_Y;
                    end
                end else begin
                    seq_count <= 0;
                end
            end
            WAIT_Y: begin
                if (y) begin
                    state <= G_SET;
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