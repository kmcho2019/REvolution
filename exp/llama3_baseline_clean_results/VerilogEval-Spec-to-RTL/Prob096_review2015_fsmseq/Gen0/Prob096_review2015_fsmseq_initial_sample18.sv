module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enum for the states
enum logic [2:0] {
    IDLE,
    GOT_11,
    GOT_110,
    GOT_1101,
    FOUND
} state, next_state;

always @(*) begin
    case (state)
        IDLE: next_state = (data == 1) ? GOT_11 : IDLE;
        GOT_11: next_state = (data == 1) ? GOT_110 : IDLE;
        GOT_110: next_state = (data == 0) ? GOT_1101 : IDLE;
        GOT_1101: next_state = (data == 1) ? FOUND : IDLE;
        FOUND: next_state = FOUND;
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        start_shifting <= (state == FOUND) ? 1 : 0;
    end
end

endmodule