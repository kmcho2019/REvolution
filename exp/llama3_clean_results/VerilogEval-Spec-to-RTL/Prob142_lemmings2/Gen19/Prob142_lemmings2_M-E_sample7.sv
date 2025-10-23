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

// Direction change component
reg direction;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // reset to left
    end else if ((bump_left && ~direction) || (bump_right && direction)) begin
        direction <= ~direction; // change direction
    end
end

// Falling state component
reg falling;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        falling <= 1'b0; // reset to not falling
    end else if (~ground) begin
        falling <= 1'b1; // falling
    end else if (ground && falling) begin
        falling <= 1'b0; // not falling
    end
end

// Output logic component
always @(*) begin
    walk_left = (~direction && ~falling)? 1'b1 : 1'b0;
    walk_right = (direction && ~falling)? 1'b1 : 1'b0;
    aaah = falling? 1'b1 : 1'b0;
end

endmodule