module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

typedef enum logic [1:0] {
    IDLE,
    RISING_EDGE,
    FALLING_EDGE
} state_t;

state_t current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        current_state <= next_state;
        case (next_state)
            RISING_EDGE: begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            FALLING_EDGE: begin
                rise <= 1'b0;
                down <= 1'b1;
            end
            default: begin
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            if (a && !a_prev) begin
                next_state = RISING_EDGE;
            end else if (!a && a_prev) begin
                next_state = FALLING_EDGE;
            end else begin
                next_state = IDLE;
            end
        end
        RISING_EDGE: begin
            next_state = IDLE;
        end
        FALLING_EDGE: begin
            next_state = IDLE;
        end
    endcase
end

reg a_prev;
always @(posedge clk) begin
    a_prev <= a;
end

endmodule