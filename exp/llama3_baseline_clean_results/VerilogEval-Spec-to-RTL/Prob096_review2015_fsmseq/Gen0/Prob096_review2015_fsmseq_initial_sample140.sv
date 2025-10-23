module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

typedef enum {
    IDLE,
    SEEN_1,
    SEEN_11,
    SEEN_110,
    FINAL
} state_t;

state_t current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data) begin
                    current_state <= SEEN_1;
                end else begin
                    current_state <= IDLE;
                end
            end
            SEEN_1: begin
                if (data) begin
                    current_state <= SEEN_11;
                end else begin
                    current_state <= SEEN_0;
                end
            end
            SEEN_0: begin
                if (data) begin
                    current_state <= SEEN_1;
                end else begin
                    current_state <= IDLE;
                end
            end
            SEEN_11: begin
                if (~data) begin
                    current_state <= SEEN_110;
                end else begin
                    current_state <= SEEN_1;
                end
            end
            SEEN_110: begin
                if (data) begin
                    current_state <= FINAL;
                end else begin
                    current_state <= IDLE;
                end
            end
            FINAL: begin
                start_shifting <= 1;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset || (current_state != FINAL)) begin
        start_shifting <= (current_state == FINAL);
    end
end

endmodule