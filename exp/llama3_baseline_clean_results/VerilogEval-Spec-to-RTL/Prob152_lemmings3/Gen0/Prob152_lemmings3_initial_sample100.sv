module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state;
reg [1:0] nextState;
reg previousDirection;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00;  // WALK_LEFT
        previousDirection <= 1'b0;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        2'b00: begin  // WALK_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            if(!ground) begin
                nextState = 2'b10;  // FALLING
            end else if(dig) begin
                nextState = 2'b11;  // DIGGING
            end else if(bump_left && !bump_right) begin
                nextState = 2'b01;  // WALK_RIGHT
            end else if(!bump_left && bump_right) begin
                nextState = 2'b00;  // stay in WALK_LEFT
            end else if(bump_left && bump_right) begin
                nextState = 2'b01;  // WALK_RIGHT
            end else begin
                nextState = 2'b00;  // stay in WALK_LEFT
            end
            previousDirection = 1'b0;
        end
        2'b01: begin  // WALK_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            if(!ground) begin
                nextState = 2'b10;  // FALLING
            end else if(dig) begin
                nextState = 2'b11;  // DIGGING
            end else if(bump_right && !bump_left) begin
                nextState = 2'b00;  // WALK_LEFT
            end else if(!bump_right && bump_left) begin
                nextState = 2'b01;  // stay in WALK_RIGHT
            end else if(bump_right && bump_left) begin
                nextState = 2'b00;  // WALK_LEFT
            end else begin
                nextState = 2'b01;  // stay in WALK_RIGHT
            end
            previousDirection = 1'b1;
        end
        2'b10: begin  // FALLING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if(ground) begin
                if(previousDirection) begin
                    nextState = 2'b01;  // WALK_RIGHT
                end else begin
                    nextState = 2'b00;  // WALK_LEFT
                end
            end else begin
                nextState = 2'b10;  // stay in FALLING
            end
        end
        2'b11: begin  // DIGGING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
            if(!ground) begin
                nextState = 2'b10;  // FALLING
            end else begin
                nextState = 2'b11;  // stay in DIGGING
            end
        end
    endcase
end

endmodule