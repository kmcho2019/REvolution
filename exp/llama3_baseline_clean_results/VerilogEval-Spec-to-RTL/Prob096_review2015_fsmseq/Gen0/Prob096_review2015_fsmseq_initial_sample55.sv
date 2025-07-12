module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enum for states
enum logic [2:0] {
    IDLE,
    STATE_1,
    STATE_11,
    STATE_110,
    FINAL
} state, next_state;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == FINAL) begin
            start_shifting <= 1;
        end
    end
end

// Combinational logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data) begin
                next_state <= STATE_1;
            end else begin
                next_state <= IDLE;
            end
        end
        STATE_1: begin
            if (data) begin
                next_state <= STATE_11;
            end else begin
                next_state <= STATE_110;
            end
        end
        STATE_11: begin
            if (data) begin
                next_state <= STATE_11;
            end else begin
                next_state <= STATE_110;
            end
        end
        STATE_110: begin
            if (data) begin
                next_state <= STATE_11;
            end else begin
                next_state <= FINAL;
            end
        end
        FINAL: begin
            next_state <= FINAL;
        end
        default: begin
            next_state <= IDLE;
        end
    endcase
end

endmodule