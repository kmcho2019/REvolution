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
reg walking_left;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_left <= 1'b1;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    aaah <= 1'b1;
                end else if (dig && ground) begin
                    state <= DIGGING;
                    digging <= 1'b1;
                end else if (bump_left) begin
                    walking_left <= 1'b0;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else if (bump_right) begin
                    walking_left <= 1'b1;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            FALLING: begin
                if (ground) begin
                    state <= WALKING;
                    aaah <= 1'b0;
                    if (walking_left) begin
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    digging <= 1'b0;
                    aaah <= 1'b1;
                end
            end
        endcase
    end
end

endmodule