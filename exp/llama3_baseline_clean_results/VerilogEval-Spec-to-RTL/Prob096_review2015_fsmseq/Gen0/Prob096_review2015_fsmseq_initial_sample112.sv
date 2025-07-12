module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    FOUND
} state, next_state;

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (next_state == FOUND) begin
            start_shifting <= 1;
        end else if (next_state == IDLE) begin
            start_shifting <= 0;
        end else begin
            start_shifting <= start_shifting;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1) begin
                next_state <= S1;
            end else begin
                next_state <= IDLE;
            end
        end
        S1: begin
            if (data == 1) begin
                next_state <= S2;
            end else if (data == 0) begin
                next_state <= IDLE;
            end else begin
                next_state <= S1;
            end
        end
        S2: begin
            if (data == 0) begin
                next_state <= S3;
            end else if (data == 1) begin
                next_state <= S1;
            end else begin
                next_state <= S2;
            end
        end
        S3: begin
            if (data == 1) begin
                next_state <= FOUND;
            end else if (data == 0) begin
                next_state <= IDLE;
            end else begin
                next_state <= S3;
            end
        end
        FOUND: begin
            next_state <= FOUND;
        end
        default: next_state <= IDLE;
    endcase
end

endmodule