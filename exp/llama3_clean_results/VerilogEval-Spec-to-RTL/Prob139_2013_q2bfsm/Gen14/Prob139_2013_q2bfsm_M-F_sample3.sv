module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [2:0] {RESET, PULSE, SEQ_DETECT, WAIT_Y, FINAL_G1, FINAL_G0} state, next_state;

reg [2:0] x_seq = 0; // Shift register to hold last three values of x
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
                if (resetn) begin
                    next_state <= PULSE;
                end else begin
                    next_state <= RESET;
                end
                f <= 0;
                g <= 0;
            end
            PULSE: begin
                next_state <= SEQ_DETECT;
                f <= 1;
                g <= 0;
            end
            SEQ_DETECT: begin
                x_seq <= {x, x_seq[2:1]}; // Shift in new value of x
                if (x_seq == 3'b101) begin // Check for sequence '1, 0, 1'
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
                    next_state <= FINAL_G1; // Maintain g = 1
                    g <= 1;
                end else if (y_timer == 2'd2) begin // Check if y is 0 for two cycles
                    next_state <= FINAL_G0; // Set g = 0 permanently
                    g <= 0;
                end else begin
                    next_state <= WAIT_Y;
                end
                f <= 0;
            end
            FINAL_G1: begin
                next_state <= FINAL_G1; // Stay in this state with g = 1
                g <= 1;
                f <= 0;
            end
            FINAL_G0: begin
                next_state <= FINAL_G0; // Stay in this state with g = 0
                g <= 0;
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