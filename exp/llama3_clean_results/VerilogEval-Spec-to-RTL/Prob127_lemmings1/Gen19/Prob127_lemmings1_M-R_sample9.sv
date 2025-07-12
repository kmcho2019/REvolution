module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

typedef enum logic [0:0] {
    LEFT,
    RIGHT
} state_t;

state_t current_state, next_state;

always_comb begin
    case (current_state)
        LEFT: begin
            if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
            end
        end
        default: next_state = LEFT;
    endcase
    
    if (bump_left && bump_right) begin
        next_state = (current_state == LEFT) ? RIGHT : LEFT;
    end
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= LEFT; // Initialize state to walking left
    end else begin
        current_state <= next_state;
    end
end

assign walk_left = (current_state == LEFT);
assign walk_right = (current_state == RIGHT);

endmodule