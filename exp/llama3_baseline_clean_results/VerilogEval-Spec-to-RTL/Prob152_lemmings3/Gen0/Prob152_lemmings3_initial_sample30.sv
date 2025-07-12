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

reg [2:0] state; // 3 bits to represent 5 states
reg [2:0] nextState;

// State encoding:
// 3'b000: WALK_LEFT
// 3'b001: WALK_RIGHT
// 3'b010: FALLING
// 3'b011: DIGGING_LEFT
// 3'b100: DIGGING_RIGHT

always @(*) begin
    case(state)
        3'b000: begin // WALK_LEFT
            if (~ground) begin
                nextState = 3'b010; // FALLING
            end else if (dig) begin
                nextState = 3'b011; // DIGGING_LEFT
            end else if (bump_left) begin
                nextState = 3'b001; // WALK_RIGHT
            end else if (bump_right) begin
                nextState = 3'b000; // WALK_LEFT
            end else begin
                nextState = 3'b000; // WALK_LEFT
            end
        end
        3'b001: begin // WALK_RIGHT
            if (~ground) begin
                nextState = 3'b010; // FALLING
            end else if (dig) begin
                nextState = 3'b100; // DIGGING_RIGHT
            end else if (bump_left) begin
                nextState = 3'b001; // WALK_RIGHT
            end else if (bump_right) begin
                nextState = 3'b000; // WALK_LEFT
            end else begin
                nextState = 3'b001; // WALK_RIGHT
            end
        end
        3'b010: begin // FALLING
            if (ground) begin
                if (state == 3'b000) begin
                    nextState = 3'b000; // WALK_LEFT
                end else if (state == 3'b001) begin
                    nextState = 3'b001; // WALK_RIGHT
                end else if (state == 3'b011) begin
                    nextState = 3'b000; // WALK_LEFT
                end else if (state == 3'b100) begin
                    nextState = 3'b001; // WALK_RIGHT
                end
            end else begin
                nextState = 3'b010; // FALLING
            end
        end
        3'b011: begin // DIGGING_LEFT
            if (~ground) begin
                nextState = 3'b010; // FALLING
            end else begin
                nextState = 3'b011; // DIGGING_LEFT
            end
        end
        3'b100: begin // DIGGING_RIGHT
            if (~ground) begin
                nextState = 3'b010; // FALLING
            end else begin
                nextState = 3'b100; // DIGGING_RIGHT
            end
        end
        default: begin
            nextState = 3'b000; // WALK_LEFT
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b000; // WALK_LEFT
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        3'b000: begin // WALK_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        3'b001: begin // WALK_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        3'b010: begin // FALLING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        3'b011: begin // DIGGING_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        3'b100: begin // DIGGING_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule