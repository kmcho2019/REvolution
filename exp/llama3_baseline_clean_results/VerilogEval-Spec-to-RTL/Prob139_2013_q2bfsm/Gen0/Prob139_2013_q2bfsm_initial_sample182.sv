module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
typedef enum logic [2:0] {
    STATE_A,         // Initial state
    STATE_F,         // Set f to 1
    STATE_X_SEQ,     // Monitor x sequence
    STATE_G_SET,     // Set g to 1
    STATE_Y_MON,     // Monitor y
    STATE_G_PERM     // Permanent g state
} state_t;

state_t current_state, next_state;
reg [1:0] x_sequence; // Counter for x sequence
reg [1:0] y_timeout;  // Counter for y timeout

always @(*) begin
    case (current_state)
        STATE_A: begin
            if (~resetn) begin
                next_state = STATE_A;
                f = 0;
                g = 0;
            end else begin
                next_state = STATE_F;
                f = 1;
                g = 0;
            end
        end
        STATE_F: begin
            next_state = STATE_X_SEQ;
            f = 0;
            g = 0;
            x_sequence = 0;
        end
        STATE_X_SEQ: begin
            if (x_sequence == 0 && x) begin
                x_sequence = 1;
            end else if (x_sequence == 1 && ~x) begin
                x_sequence = 2;
            end else if (x_sequence == 2 && x) begin
                x_sequence = 3;
                next_state = STATE_G_SET;
            end else begin
                x_sequence = 0;
            end
            f = 0;
            g = 0;
            next_state = STATE_X_SEQ;
        end
        STATE_G_SET: begin
            next_state = STATE_Y_MON;
            f = 0;
            g = 1;
            y_timeout = 0;
        end
        STATE_Y_MON: begin
            if (y) begin
                next_state = STATE_G_PERM;
            end else if (y_timeout < 2) begin
                y_timeout = y_timeout + 1;
                next_state = STATE_Y_MON;
            end else begin
                next_state = STATE_G_PERM;
                g = 0;
            end
            f = 0;
        end
        STATE_G_PERM: begin
            next_state = STATE_G_PERM;
            f = 0;
            g = 1;
        end
        default: begin
            next_state = STATE_A;
            f = 0;
            g = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
end

endmodule