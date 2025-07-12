module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define the states of the finite-state machine
enum logic [2:0] {
    IDLE,
    SEEN_1,
    SEEN_11,
    SEEN_110,
    SEEN_1101
} state, next_state;

always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1'b1) next_state = SEEN_1;
            else next_state = IDLE;
        end
        SEEN_1: begin
            if (data == 1'b1) next_state = SEEN_11;
            else if (data == 1'b0) next_state = IDLE;
        end
        SEEN_11: begin
            if (data == 1'b0) next_state = SEEN_110;
            else if (data == 1'b1) next_state = SEEN_1;
        end
        SEEN_110: begin
            if (data == 1'b1) next_state = SEEN_1101;
            else if (data == 1'b0) next_state = IDLE;
        end
        SEEN_1101: begin
            next_state = SEEN_1101;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end
    else begin
        state <= next_state;
        if (state == SEEN_1101) start_shifting <= 1;
        else if (state != SEEN_1101 && state != IDLE && next_state == IDLE) start_shifting <= 0;
    end
end

endmodule