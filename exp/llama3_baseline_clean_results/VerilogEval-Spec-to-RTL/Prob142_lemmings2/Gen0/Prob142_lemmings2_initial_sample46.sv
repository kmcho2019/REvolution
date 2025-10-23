module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    output          walk_left,
    output          walk_right,
    output          aaah
);

parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL = 2'b10;
parameter RESUME_LEFT = 2'b11;
parameter RESUME_RIGHT = 2'b10;

reg [1:0] state;
reg [1:0] nextState;

always @(*) begin
    case(state)
        WALK_LEFT: begin
            if (bump_right || (bump_left && !bump_right)) begin
                nextState = WALK_RIGHT;
            end else if (bump_left && bump_right) begin
                nextState = WALK_RIGHT;
            end else if (!ground) begin
                nextState = RESUME_LEFT;
            end else begin
                nextState = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_left || (bump_right && !bump_left)) begin
                nextState = WALK_LEFT;
            end else if (bump_left && bump_right) begin
                nextState = WALK_LEFT;
            end else if (!ground) begin
                nextState = RESUME_RIGHT;
            end else begin
                nextState = WALK_RIGHT;
            end
        end
        FALL: begin
            nextState = FALL;
        end
        RESUME_LEFT: begin
            if (ground) begin
                nextState = WALK_LEFT;
            end else begin
                nextState = RESUME_LEFT;
            end
        end
        RESUME_RIGHT: begin
            if (ground) begin
                nextState = WALK_RIGHT;
            end else begin
                nextState = RESUME_RIGHT;
            end
        end
        default: begin
            nextState = WALK_LEFT;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= nextState;
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
        FALL: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        RESUME_LEFT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        RESUME_RIGHT: begin
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