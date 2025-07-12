module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [2:0] {RESET, PULSE, SEQ_DETECT, WAIT_Y} state, next_state;

reg [1:0] x_seq = 0; // Shift register to hold last two values of x
reg [1:0] y_timer = 0; // Timer to count cycles after sequence detection

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_seq <= 0;
        y_timer <= 0;
    end else begin
        case (state)
            RESET: begin
                next_state <= PULSE;
                f <= 0;
                g <= 0;
            end
            PULSE: begin
                next_state <= SEQ_DETECT;
                f <= 1;
                g <= 0;
            end
            SEQ_DETECT: begin
                x_seq <= {x, x_seq[0]};
                if (x_seq == 2'b101) begin
                    next_state <= WAIT_Y;
                end else begin
                    next_state <= SEQ_DETECT;
                end
                f <= 0;
                g <= 0;
            end
            WAIT_Y: begin
                y_timer <= y_timer + 1;
                if (y) begin
                    next_state <= RESET;
                    g <= 1;
                end else if (y_timer == 2'b11) begin
                    next_state <= RESET;
                    g <= 0;
                end else begin
                    next_state <= WAIT_Y;
                    g <= 0;
                end
                f <= 0;
            end
            default: begin
                next_state <= RESET;
                f <= 0;
                g <= 0;
            end
        endcase
        state <= next_state;
    end
end

endmodule