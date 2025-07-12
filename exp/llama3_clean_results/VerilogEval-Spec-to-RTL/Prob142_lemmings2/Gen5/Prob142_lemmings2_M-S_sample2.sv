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
reg walk_dir; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // WALK_LEFT
        walk_dir <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
    end else begin
        case (state)
            0, 1: begin // WALK_LEFT or WALK_RIGHT
                if (ground == 0) begin
                    state <= 2; // FALLING
                end else begin
                    if (walk_dir == 0 && bump_right) begin
                        walk_dir <= 1;
                        state <= 1; // WALK_RIGHT
                    end else if (walk_dir == 1 && bump_left) begin
                        walk_dir <= 0;
                        state <= 0; // WALK_LEFT
                    end
                end
                walk_left <= ~walk_dir;
                walk_right <= walk_dir;
                aaah <= 0;
            end
            2: begin // FALLING
                if (ground == 1) begin
                    state <= walk_dir ? 1 : 0; // resume previous walking state
                end
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
            end
        endcase
    end
end

endmodule