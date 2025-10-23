module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enum for states
typedef enum logic [2:0] {
    IDLE,
    DETECTED_1,
    DETECTED_11,
    DETECTED_110,
    DETECTED_1101
} state_t;

state_t current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data == 1) begin
                    current_state <= DETECTED_1;
                end else begin
                    current_state <= IDLE;
                end
            end
            DETECTED_1: begin
                if (data == 1) begin
                    current_state <= DETECTED_11;
                end else if (data == 0) begin
                    current_state <= IDLE;
                end
            end
            DETECTED_11: begin
                if (data == 0) begin
                    current_state <= DETECTED_110;
                end else begin
                    current_state <= DETECTED_1;
                end
            end
            DETECTED_110: begin
                if (data == 1) begin
                    current_state <= DETECTED_1101;
                end else begin
                    current_state <= IDLE;
                end
            end
            DETECTED_1101: begin
                start_shifting <= 1;
                current_state <= DETECTED_1101;
            end
        endcase
    end
end

endmodule