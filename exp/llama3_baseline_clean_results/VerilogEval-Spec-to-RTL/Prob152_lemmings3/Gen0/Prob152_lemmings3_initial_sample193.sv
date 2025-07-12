module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    input           dig,
    output          walk_left,
    output          walk_right,
    output          aaah,
    output          digging
);

reg [1:0] state;
reg [1:0] nextState;

// Initialize states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// Output logic
always @(state) begin
    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
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

// Next state logic
always @(state, bump_left, bump_right, ground, dig) begin
    case(state)
        WALK_LEFT: begin
            if (!ground) begin
                nextState = FALLING;
            end else if (dig) begin
                nextState = DIGGING;
            end else if (bump_left) begin
                nextState = WALK_RIGHT;
            end else if (bump_right) begin
                nextState = WALK_LEFT;
            end else begin
                nextState = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                nextState = FALLING;
            end else if (dig) begin
                nextState = DIGGING;
            end else if (bump_right) begin
                nextState = WALK_LEFT;
            end else if (bump_left) begin
                nextState = WALK_RIGHT;
            end else begin
                nextState = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (state == WALK_LEFT) begin
                    nextState = WALK_LEFT;
                end else begin
                    nextState = WALK_RIGHT;
                end
            end else begin
                nextState = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                nextState = FALLING;
            end else begin
                nextState = DIGGING;
            end
        end
        default: begin
            nextState = WALK_LEFT;
        end
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= nextState;
    end
end

endmodule