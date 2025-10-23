module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for each prefix of the sequence 1101
enum logic [1:0] {
    IDLE = 2'b00,
    SEEN_1 = 2'b01,
    SEEN_11 = 2'b10,
    SEEN_110 = 2'b11
} state, next_state;

// Current state and next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (state == SEEN_110 && data == 1'b1) begin
            start_shifting <= 1'b1;
        end else if (reset) begin
            start_shifting <= 1'b0;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1'b1) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1: begin
            if (data == 1'b1) begin
                next_state = SEEN_11;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_11: begin
            if (data == 1'b0) begin
                next_state = SEEN_110;
            end else begin
                next_state = SEEN_1;
            end
        end
        SEEN_110: begin
            if (data == 1'b1) begin
                next_state = SEEN_11; // This state is not actually needed, simplified the code
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule