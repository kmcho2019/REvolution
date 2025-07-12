module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for the FSM
enum logic [2:0] {
    S_IDLE = 3'b000,
    S_1 = 3'b001,
    S_11 = 3'b010,
    S_110 = 3'b011,
    S_1101 = 3'b100,
    S_SHIFTING = 3'b101
} state, next_state;

// Current state logic
always @(posedge clk) begin
    if (reset) begin
        state <= S_IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S_SHIFTING) begin
            start_shifting <= 1'b1;
        end else if (state == S_1101) begin
            start_shifting <= 1'b1;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        S_IDLE: begin
            if (data) begin
                next_state <= S_1;
            end else begin
                next_state <= S_IDLE;
            end
        end
        S_1: begin
            if (data) begin
                next_state <= S_11;
            end else begin
                next_state <= S_IDLE;
            end
        end
        S_11: begin
            if (data) begin
                next_state <= S_11;
            end else begin
                next_state <= S_110;
            end
        end
        S_110: begin
            if (data) begin
                next_state <= S_1;
            end else begin
                next_state <= S_1101;
            end
        end
        S_1101: begin
            next_state <= S_SHIFTING;
        end
        S_SHIFTING: begin
            if (reset) begin
                next_state <= S_IDLE;
            end else begin
                next_state <= S_SHIFTING;
            end
        end
        default: next_state <= S_IDLE;
    endcase
end

endmodule