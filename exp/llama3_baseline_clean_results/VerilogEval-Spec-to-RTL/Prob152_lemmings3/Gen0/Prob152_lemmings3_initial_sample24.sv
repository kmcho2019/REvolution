module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state;
reg [0:0] walk_dir;
reg [0:0] prev_walk_dir;

parameter WALKING_LEFT = 2'b00;
parameter WALKING_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        walk_dir <= 1'b0;
        prev_walk_dir <= 1'b0;
    end else begin
        case (state)
            WALKING_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                    prev_walk_dir <= walk_dir;
                end else if (bump_left) begin
                    state <= WALKING_RIGHT;
                    walk_dir <= 1'b1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                    walk_dir <= 1'b0;
                end
            end
            WALKING_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                    prev_walk_dir <= walk_dir;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                    walk_dir <= 1'b0;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALKING_RIGHT;
                    walk_dir <= 1'b1;
                end
            end
            FALLING: begin
                if (ground) begin
                    state <= walk_dir ? WALKING_RIGHT : WALKING_LEFT;
                    walk_dir <= prev_walk_dir;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                    prev_walk_dir <= walk_dir;
                end
            end
        endcase
    end
end

assign walk_left = (state == WALKING_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == WALKING_RIGHT) ? 1'b1 : 1'b0;
assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == DIGGING) ? 1'b1 : 1'b0;

endmodule