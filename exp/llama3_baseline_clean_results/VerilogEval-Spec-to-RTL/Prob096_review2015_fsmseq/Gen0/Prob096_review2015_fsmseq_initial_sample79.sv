module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

typedef enum logic [2:0] {
    IDLE,
    DETECT_1,
    DETECT_11,
    DETECT_110,
    FOUND
} state_t;

state_t current_state = IDLE;

always @ (posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data) begin
                    current_state <= DETECT_1;
                end else begin
                    current_state <= IDLE;
                end
            end
            DETECT_1: begin
                if (data) begin
                    current_state <= DETECT_11;
                end else begin
                    current_state <= DETECT_1;
                end
            end
            DETECT_11: begin
                if (~data) begin
                    current_state <= DETECT_110;
                end else begin
                    current_state <= DETECT_1;
                end
            end
            DETECT_110: begin
                if (data) begin
                    current_state <= FOUND;
                end else begin
                    current_state <= IDLE;
                end
            end
            FOUND: begin
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule