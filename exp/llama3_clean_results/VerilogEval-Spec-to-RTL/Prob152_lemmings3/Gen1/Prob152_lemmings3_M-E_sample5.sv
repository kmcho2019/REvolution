module DirectionController(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  [1:0] current_direction, // 2'b00 - Left, 2'b01 - Right, 2'b10 - Invalid (for reset), 2'b11 - Falling/Not Walking
    output [1:0] next_direction
);

reg [1:0] direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 2'b00; // Reset to walking left
    end else begin
        if (bump_left && !bump_right) begin
            direction <= 2'b01; // Walk right if bumped left
        end else if (bump_right && !bump_left) begin
            direction <= 2'b00; // Walk left if bumped right
        end else if (bump_left && bump_right) begin
            // Switch direction if bumped both sides
            direction <= (direction == 2'b00) ? 2'b01 : 2'b00;
        end else begin
            direction <= direction; // No change if no bumps
        end
    end
end

assign next_direction = direction;

endmodule

module ActionController(
    input  clk,
    input  areset,
    input  ground,
    input  dig,
    input  [1:0] current_direction, // 2'b00 - Left, 2'b01 - Right, 2'b10 - Invalid (for reset), 2'b11 - Falling/Not Walking
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg walk_left_reg, walk_right_reg, aaah_reg, digging_reg;
reg [1:0] current_action;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left_reg <= 1'b1; // Start walking left
        walk_right_reg <= 1'b0;
        aaah_reg <= 1'b0;
        digging_reg <= 1'b0;
        current_action <= 2'b00; // Walking left
    end else begin
        if (!ground) begin
            // Falling, set aaah and reset walk and dig
            walk_left_reg <= 1'b0;
            walk_right_reg <= 1'b0;
            aaah_reg <= 1'b1;
            digging_reg <= 1'b0;
        end else if (dig && (current_action == 2'b00 || current_action == 2'b01)) begin
            // Digging
            walk_left_reg <= 1'b0;
            walk_right_reg <= 1'b0;
            aaah_reg <= 1'b0;
            digging_reg <= 1'b1;
        end else if (current_action == 2'b10) begin
            // Not walking (falling or digging), check direction and set walk signals
            if (current_direction == 2'b00) begin
                walk_left_reg <= 1'b1;
                walk_right_reg <= 1'b0;
            end else if (current_direction == 2'b01) begin
                walk_left_reg <= 1'b0;
                walk_right_reg <= 1'b1;
            end
            aaah_reg <= 1'b0;
            digging_reg <= 1'b0;
        end else begin
            // Walking, update based on direction
            walk_left_reg <= (current_direction == 2'b00) ? 1'b1 : 1'b0;
            walk_right_reg <= (current_direction == 2'b01) ? 1'b1 : 1'b0;
            aaah_reg <= 1'b0;
            digging_reg <= 1'b0;
        end
    end
end

assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;
assign digging = digging_reg;

endmodule

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

wire [1:0] current_direction;

DirectionController dir_ctrl(
    .clk(clk),
    .areset(areset),
    .bump_left(bump_left),
    .bump_right(bump_right),
    .current_direction(current_direction),
    .next_direction(current_direction)
);

ActionController action_ctrl(
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .dig(dig),
    .current_direction(current_direction),
    .walk_left(walk_left),
    .walk_right(walk_right),
    .aaah(aaah),
    .digging(digging)
);

endmodule