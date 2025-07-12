module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define the states
enum logic [0:0] {LEFT, RIGHT} state, next_state;

// Moore machine with two states
always @(*) begin
    case (state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            if (bump_left) next_state = RIGHT;
            else next_state = LEFT;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            if (bump_right) next_state = LEFT;
            else next_state = RIGHT;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            next_state = LEFT;
        end
    endcase
end

// State transition on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) state <= LEFT;
    else state <= next_state;
end

endmodule