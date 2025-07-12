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

reg [1:0] state;  // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING
reg [1:0] nextState;

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
            end else if(bump_left) begin
                nextState = 2'b01;  // WALK_RIGHT
            end else begin
                nextState = 2'b00;  // WALK_LEFT
            end
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
            end else if(bump_right) begin
                nextState = 2'b00;  // WALK_LEFT
            end else begin
                nextState = 2'b01;  // WALK_RIGHT
            end
        end
        2'b10: begin  // FALLING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if(ground) begin
                if(state[0] == 1'b0) begin
                    nextState = 2'b00;  // WALK_LEFT
                end else begin
                    nextState = 2'b01;  // WALK_RIGHT
                end
            end else begin
                nextState = 2'b10;  // FALLING
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
                nextState = 2'b11;  // DIGGING
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00;  // Reset to WALK_LEFT
    end else begin
        state <= nextState;
    end
end

endmodule