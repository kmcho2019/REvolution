module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING
reg walk_dir; // 0: WALK_LEFT, 1: WALK_RIGHT

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // WALK_LEFT
        walk_dir <= 0;
    end else begin
        case (state)
            0, 1: begin // WALK_LEFT or WALK_RIGHT
                if (ground == 0) begin
                    state <= 2; // FALLING
                end else if (bump_left == 1) begin
                    walk_dir <= 1; // WALK_RIGHT
                    state <= 1;
                end else if (bump_right == 1) begin
                    walk_dir <= 0; // WALK_LEFT
                    state <= 0;
                end
            end
            2: begin // FALLING
                if (ground == 1) begin
                    state <= walk_dir? 1 : 0; // resume previous walking state
                end
            end
        endcase
    end
end

assign walk_left = (state == 0 || (state == 2 && walk_dir == 0))? 0 : walk_dir? 0 : 1;
assign walk_right = (state == 1 || (state == 2 && walk_dir == 1))? 0 : walk_dir? 1 : 0;
assign aaah = state == 2;

endmodule