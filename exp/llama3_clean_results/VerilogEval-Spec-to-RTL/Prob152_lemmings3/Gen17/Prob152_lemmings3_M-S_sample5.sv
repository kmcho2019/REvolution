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

reg walking_left;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_left <= 1'b1;
        digging <= 1'b0;
    end else begin
        if (!ground) begin
            digging <= 1'b0;
        end else if (dig &&!digging) begin
            digging <= 1'b1;
        end

        if (bump_left &&!ground) begin
            // Do nothing
        end else if (bump_left) begin
            walking_left <= 1'b0;
        end

        if (bump_right &&!ground) begin
            // Do nothing
        end else if (bump_right) begin
            walking_left <= 1'b1;
        end

        if (ground &&!digging) begin
            // Do nothing
        end
    end
end

assign walk_left = ground && walking_left &&!digging? 1'b1 : 1'b0;
assign walk_right = ground &&!walking_left &&!digging? 1'b1 : 1'b0;
assign aaah =!ground? 1'b1 : 1'b0;
assign digging = digging && ground? 1'b1 : 1'b0;

endmodule