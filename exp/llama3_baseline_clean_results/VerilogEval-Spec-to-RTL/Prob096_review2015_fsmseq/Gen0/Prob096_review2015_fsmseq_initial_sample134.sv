module TopModule(
    input           clk,
    input           reset,
    input           data,
    output logic    start_shifting
);

// Define the states for the finite-state machine
typedef enum logic[3:0] {
    IDLE      = 4'b0000,
    DETECT_1  = 4'b0001,
    DETECT_11 = 4'b0011,
    DETECT_110 = 4'b0110,
    DETECT_1101 = 4'b1101,
    FOUND     = 4'b1111
} state_t;

state_t current_state;
state_t next_state;

always_comb begin
    case (current_state)
        IDLE: begin
            if (data == 1) begin
                next_state = DETECT_1;
            end else begin
                next_state = IDLE;
            end
        end
        DETECT_1: begin
            if (data == 1) begin
                next_state = DETECT_11;
            end else if (data == 0) begin
                next_state = IDLE;
            end
        end
        DETECT_11: begin
            if (data == 0) begin
                next_state = DETECT_110;
            end else begin
                next_state = DETECT_1;
            end
        end
        DETECT_110: begin
            if (data == 1) begin
                next_state = DETECT_1101;
            end else begin
                next_state = IDLE;
            end
        end
        DETECT_1101: begin
            if (data == 1 || data == 0) begin
                next_state = FOUND;
            end
        end
        FOUND: begin
            next_state = FOUND;
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == FOUND) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule