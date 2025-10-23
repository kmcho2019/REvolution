module TopModule (
    input           clk,
    input           aresetn,
    input           x,
    output logic    z
);

typedef enum logic [1:0] {
    IDLE,
    SEEN_1,
    SEEN_10
} state_type;

state_type current_state, next_state;

always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    next_state = current_state;
    z = 1'b0;

    case (current_state)
        IDLE: begin
            if (x) begin
                next_state = SEEN_1;
            end
        end
        SEEN_1: begin
            if (x) begin
                next_state = SEEN_1;
            end else begin
                next_state = SEEN_10;
            end
        end
        SEEN_10: begin
            if (x) begin
                z = 1'b1;
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule