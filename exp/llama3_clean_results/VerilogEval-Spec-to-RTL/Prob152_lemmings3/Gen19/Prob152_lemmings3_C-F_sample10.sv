module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

typedef enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING
} state_t;

state_t state;
reg walk_direction; // 0: left, 1: right

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 0; // left
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig && ground) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    walk_direction <= 1; // right
                end else if (bump_right) begin
                    walk_direction <= 0; // left
                end
            end
            FALLING: begin
                if (ground) begin
                    state <= WALKING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end
            end
        endcase
    end
end

assign walk_left = (state == WALKING &&!walk_direction)? 1'b1 : 1'b0;
assign walk_right = (state == WALKING && walk_direction)? 1'b1 : 1'b0;
assign aaah = (state == FALLING)? 1'b1 : 1'b0;
assign digging = (state == DIGGING)? 1'b1 : 1'b0;

endmodule