module TopModule(
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    input         ground,
    output        walk_left,
    output        walk_right,
    output        aaah
);

reg [1:0] state;
reg [1:0] nextState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (bump_left) begin
                nextState = 2'b01; // walk right
            end else if (~ground) begin
                nextState = 2'b10; // falling
            end else begin
                nextState = 2'b00; // continue walking left
            end
        end
        2'b01: begin // walking right
            if (bump_right) begin
                nextState = 2'b00; // walk left
            end else if (~ground) begin
                nextState = 2'b10; // falling
            end else begin
                nextState = 2'b01; // continue walking right
            end
        end
        2'b10: begin // falling
            if (ground) begin
                // if previously walking left, resume walking left
                // if previously walking right, resume walking right
                nextState = (bump_left || bump_right)? (state == 2'b10)? state : (state == 2'b00)? 2'b01 : 2'b00 : (state == 2'b10)? state : (state == 2'b00)? 2'b00 : 2'b01;
            end else begin
                nextState = 2'b10; // continue falling
            end
        end
        default: begin
            nextState = 2'b00;
        end
    endcase
end

always @(*) begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule