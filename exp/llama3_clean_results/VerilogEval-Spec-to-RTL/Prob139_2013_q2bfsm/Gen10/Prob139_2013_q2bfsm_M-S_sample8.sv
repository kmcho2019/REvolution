module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enumerate states
enum logic [1:0] {RESET, PULSE, SEQ_DETECT, Y_WAIT, G_SET, G_CLEAR} state, next_state;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        
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
                if (x == 1'b1) begin
                    if (x_seq == 2'b01) begin
                        next_state <= Y_WAIT;
                        x_seq <= 0;
                    end else begin
                        x_seq <= {x, x_seq[0]};
                        next_state <= SEQ_DETECT;
                    end
                end else if (x == 1'b0) begin
                    x_seq <= {x, x_seq[0]};
                    next_state <= SEQ_DETECT;
                end else begin
                    next_state <= SEQ_DETECT;
                end
                f <= 0;
                g <= 0;
            end
            Y_WAIT: begin
                if (y_timer == 2'b11) begin
                    if (y_seen) begin
                        next_state <= G_SET;
                    end else begin
                        next_state <= G_CLEAR;
                    end
                end else begin
                    y_timer <= y_timer + 1;
                    if (y) begin
                        y_seen <= 1;
                    end
                    next_state <= Y_WAIT;
                end
                f <= 0;
                g <= 0;
            end
            G_SET: begin
                next_state <= G_SET;
                f <= 0;
                g <= 1;
            end
            G_CLEAR: begin
                next_state <= G_CLEAR;
                f <= 0;
                g <= 0;
            end
            default: begin
                next_state <= RESET;
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

reg [1:0] x_seq = 0; // Shift register to hold last two values of x
reg [1:0] y_timer = 0; // Timer to count cycles after sequence detection
reg y_seen = 0; // Flag to indicate y has been seen

endmodule