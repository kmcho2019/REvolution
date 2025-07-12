module WalkingDirection(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg direction; // 0: walking left, 1: walking right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0; // reset to walking left
    end else begin
        if (bump_left &&!bump_right) begin
            direction <= 1; // switch to walking right
        end else if (bump_right &&!bump_left) begin
            direction <= 0; // switch to walking left
        end
    end
end

assign walk_left =!direction;
assign walk_right = direction;

endmodule

module FallingLogic(
    input clk,
    input areset,
    input ground,
    input walk_left,
    input walk_right,
    output reg aaah,
    output reg resume_left,
    output reg resume_right
);

reg falling; // 1: falling, 0: not falling
reg prev_direction; // 0: walking left, 1: walking right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        falling <= 0; // reset to not falling
        prev_direction <= 0; // reset to walking left
    end else begin
        if (!ground &&!falling) begin
            falling <= 1; // start falling
            prev_direction <= walk_left? 0 : 1; // save previous direction
        end else if (ground && falling) begin
            falling <= 0; // stop falling
        end
    end
end

assign aaah = falling;
assign resume_left =!falling && prev_direction == 0;
assign resume_right =!falling && prev_direction == 1;

endmodule

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

WalkingDirection walking_direction(
   .clk(clk),
   .areset(areset),
   .bump_left(bump_left),
   .bump_right(bump_right),
   .walk_left(walk_left),
   .walk_right(walk_right)
);

FallingLogic falling_logic(
   .clk(clk),
   .areset(areset),
   .ground(ground),
   .walk_left(walk_left),
   .walk_right(walk_right),
   .aaah(aaah),
   .resume_left(),
   .resume_right()
);

endmodule