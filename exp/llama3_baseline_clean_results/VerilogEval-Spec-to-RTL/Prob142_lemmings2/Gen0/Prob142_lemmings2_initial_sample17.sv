module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 0: walking_left, 1: walking_right, 2: falling, 3: just_fell
reg [1:0] next_state;

// encode states
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam JUST_FELL = 2'b11;

always @(*) begin
    case(state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = JUST_FELL;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = JUST_FELL;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALK_LEFT; // resume walking left
            end else begin
                next_state = FALLING;
            end
        end
        JUST_FELL: begin
            if (ground) begin
                next_state = WALK_LEFT; // resume walking left
            end else begin
                next_state = FALLING;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        JUST_FELL: begin
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