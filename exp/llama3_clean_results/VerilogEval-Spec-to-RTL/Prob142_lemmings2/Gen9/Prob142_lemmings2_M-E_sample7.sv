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

reg walk_dir; // 1 bit to represent the walking direction (0: left, 1: right)
reg is_falling; // 1 bit to represent whether the Lemming is falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 0; // reset to walking left
        is_falling <= 0; // reset to not falling
    end else begin
        if (~ground) begin
            is_falling <= 1; // start falling
        end else if (is_falling) begin
            is_falling <= 0; // stop falling
        end

        if (~is_falling) begin
            if (bump_left) begin
                walk_dir <= 1; // walk right
            end else if (bump_right) begin
                walk_dir <= 0; // walk left
            end
        end
    end
end

assign walk_left = (~is_falling && ~walk_dir)? 1'b1 : 1'b0;
assign walk_right = (~is_falling && walk_dir)? 1'b1 : 1'b0;
assign aaah = is_falling? 1'b1 : 1'b0;

endmodule