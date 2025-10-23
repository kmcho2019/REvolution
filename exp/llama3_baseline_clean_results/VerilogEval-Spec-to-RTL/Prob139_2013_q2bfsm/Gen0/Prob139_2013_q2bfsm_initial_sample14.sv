module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

// Define the states of the FSM
enum logic [2:0] {
    STATE_A, // Reset state
    STATE_B, // Set f to 1 for one cycle
    STATE_X101_SEQ, // Detect sequence 1,0,1 on x
    STATE_X101_SEQ_1, // First 1 detected
    STATE_X101_SEQ_10, // 1,0 detected
    STATE_WAIT_Y, // Wait for y to become 1
    STATE_WAIT_Y_1, // First cycle waiting for y
    STATE_G_PERMANENT, // g is permanently 1
    STATE_G_CLEAR // g is permanently 0
} state, next_state;

// Initialize outputs
initial begin
    f = 0;
    g = 0;
end

// Sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        if (next_state == STATE_B) begin
            f <= 1;
        end else begin
            f <= 0;
        end
        if (next_state == STATE_G_PERMANENT) begin
            g <= 1;
        end else if (next_state == STATE_G_CLEAR) begin
            g <= 0;
        end
    end
end

// Combinational logic
always @(*) begin
    case (state)
        STATE_A: begin
            if (resetn) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_B: begin
            next_state = STATE_X101_SEQ;
        end
        STATE_X101_SEQ: begin
            if (x) begin
                next_state = STATE_X101_SEQ_1;
            end else begin
                next_state = STATE_X101_SEQ;
            end
        end
        STATE_X101_SEQ_1: begin
            if (!x) begin
                next_state = STATE_X101_SEQ_10;
            end else begin
                next_state = STATE_X101_SEQ;
            end
        end
        STATE_X101_SEQ_10: begin
            if (x) begin
                next_state = STATE_WAIT_Y;
            end else begin
                next_state = STATE_X101_SEQ;
            end
        end
        STATE_WAIT_Y: begin
            next_state = STATE_WAIT_Y_1;
        end
        STATE_WAIT_Y_1: begin
            if (y) begin
                next_state = STATE_G_PERMANENT;
            end else begin
                next_state = STATE_G_CLEAR;
            end
        end
        STATE_G_PERMANENT, STATE_G_CLEAR: begin
            next_state = state; // Stay in the same state
        end
        default: next_state = STATE_A;
    endcase
end

endmodule