module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enum for states
enum logic [1:0] {
    IDLE,
    SEEN_1,
    SEEN_11,
    SEEN_110,
    MATCH
} state, next_state;

// Current state register
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1) begin
                next_state <= SEEN_1;
            end else begin
                next_state <= IDLE;
            end
        end
        SEEN_1: begin
            if (data == 1) begin
                next_state <= SEEN_11;
            end else begin
                next_state <= IDLE;
            end
        end
        SEEN_11: begin
            if (data == 0) begin
                next_state <= SEEN_110;
            end else begin
                next_state <= SEEN_1;
            end
        end
        SEEN_110: begin
            if (data == 1) begin
                next_state <= MATCH;
            end else begin
                next_state <= IDLE;
            end
        end
        MATCH: begin
            next_state <= MATCH;
        end
        default: next_state <= IDLE;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 0;
    end else if (state == MATCH) begin
        start_shifting <= 1;
    end
end

endmodule