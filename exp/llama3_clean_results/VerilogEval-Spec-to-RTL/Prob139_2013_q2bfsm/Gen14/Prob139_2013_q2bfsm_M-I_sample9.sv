module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [2:0] {RESET, PULSE, SEQ_DETECT, WAIT_Y, FINAL_G1, FINAL_G0} state, next_state;

// Registers to hold sequence and timer
reg [1:0] x_seq = 0; 
reg [1:0] y_timer = 0; 

always @ (posedge clk) begin
    if (!resetn) begin
        // Reset state
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
                // Simplified sequence detection
                x_seq <= {x, x_seq[0]};
                if (x_seq == 2'b01 && x == 1) begin
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
                    next_state <= FINAL_G1;
                    g <= 1;
                end else if (y_timer == 2) begin
                    next_state <= FINAL_G0;
                    g <= 0;
                end else begin
                    next_state <= WAIT_Y;
                end
                f <= 0;
            end
            FINAL_G1: begin
                next_state <= FINAL_G1;
                g <= 1;
                f <= 0;
            end
            FINAL_G0: begin
                next_state <= FINAL_G0;
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