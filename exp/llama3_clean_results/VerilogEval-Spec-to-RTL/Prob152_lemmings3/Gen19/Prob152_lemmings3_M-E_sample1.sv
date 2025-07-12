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

// WalkingController module
module WalkingController (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);
    reg walking_direction;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            walking_direction <= 1'b0; // Default to walking left
        end else begin
            if (bump_left) begin
                walking_direction <= 1'b1; // Walk right
            end else if (bump_right) begin
                walking_direction <= 1'b0; // Walk left
            end
        end
    end

    assign walk_left = ~walking_direction;
    assign walk_right = walking_direction;
endmodule

// FallingController module
module FallingController (
    input  clk,
    input  areset,
    input  ground,
    output reg aaah
);
    reg is_falling;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            is_falling <= 1'b0;
        end else begin
            if (!ground) begin
                is_falling <= 1'b1;
            end else begin
                is_falling <= 1'b0;
            end
        end
    end

    assign aaah = is_falling;
endmodule

// DiggingController module
module DiggingController (
    input  clk,
    input  areset,
    input  dig,
    input  ground,
    output reg digging
);
    reg is_digging;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            is_digging <= 1'b0;
        end else begin
            if (dig && ground) begin
                is_digging <= 1'b1;
            end else if (!ground) begin
                is_digging <= 1'b0;
            end
        end
    end

    assign digging = is_digging;
endmodule

// LemmingController module
module LemmingController (
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
    WalkingController walking_controller (
       .clk(clk),
       .areset(areset),
       .bump_left(bump_left),
       .bump_right(bump_right),
       .walk_left(walk_left),
       .walk_right(walk_right)
    );

    FallingController falling_controller (
       .clk(clk),
       .areset(areset),
       .ground(ground),
       .aaah(aaah)
    );

    DiggingController digging_controller (
       .clk(clk),
       .areset(areset),
       .dig(dig),
       .ground(ground),
       .digging(digging)
    );
endmodule

LemmingController lemming_controller (
   .clk(clk),
   .areset(areset),
   .bump_left(bump_left),
   .bump_right(bump_right),
   .ground(ground),
   .dig(dig),
   .walk_left(walk_left),
   .walk_right(walk_right),
   .aaah(aaah),
   .digging(digging)
);

endmodule