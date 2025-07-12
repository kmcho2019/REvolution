`define WalkingLeft 2'b00
`define WalkingRight 2'b01
`define Falling 2'b10
`define Digging 2'b11

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
reg [1:0] nextState;

always @(*) begin
    case (state)
        `WalkingLeft: begin
            if (!ground) begin
                nextState = `Falling;
            end else if (dig) begin
                nextState = `Digging;
            end else if (bump_left) begin
                nextState = `WalkingRight;
            end else if (bump_right) begin
                nextState = `WalkingLeft;
            end else begin
                nextState = `WalkingLeft;
            end
        end
        `WalkingRight: begin
            if (!ground) begin
                nextState = `Falling;
            end else if (dig) begin
                nextState = `Digging;
            end else if (bump_left) begin
                nextState = `WalkingLeft;
            end else if (bump_right) begin
                nextState = `WalkingRight;
            end else begin
                nextState = `WalkingRight;
            end
        end
        `Falling: begin
            if (ground) begin
                if (state == `Falling && dig) begin
                    nextState = `Digging;
                end else begin
                    nextState = `WalkingLeft;
                end
            end else begin
                nextState = `Falling;
            end
        end
        `Digging: begin
            if (!ground) begin
                nextState = `Falling;
            end else begin
                nextState = `Digging;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `WalkingLeft;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        `WalkingLeft: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        `WalkingRight: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        `Falling: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        `Digging: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

endmodule