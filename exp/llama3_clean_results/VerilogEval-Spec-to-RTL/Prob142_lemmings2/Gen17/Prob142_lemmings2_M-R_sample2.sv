module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

enum logic [1:0] {LEFT, RIGHT, FALL_LEFT, FALL_RIGHT} state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        case (state)
            LEFT: begin
                if (~ground) begin
                    state <= FALL_LEFT;
                end else if (bump_left) begin
                    state <= RIGHT;
                end
            end
            RIGHT: begin
                if (~ground) begin
                    state <= FALL_RIGHT;
                end else if (bump_right) begin
                    state <= LEFT;
                end
            end
            FALL_LEFT: begin
                if (ground) begin
                    state <= LEFT;
                end
            end
            FALL_RIGHT: begin
                if (ground) begin
                    state <= RIGHT;
                end
            end
        endcase
    end
end

assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);
assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);

endmodule