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

reg [2:0] state, next_state;

// Define states
localparam IDLE = 3'b000;
localparam WALKING_LEFT = 3'b001;
localparam WALKING_RIGHT = 3'b010;
localparam FALLING = 3'b011;
localparam DIGGING = 3'b100;

// Output logic
always @(state) begin
    case (state)
        IDLE: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALKING_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALKING_RIGHT: begin
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
    endcase
end

// Next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state calculation
always @(state, bump_left, bump_right, ground, dig) begin
    case (state)
        IDLE: begin
            if (ground) begin
                next_state = WALKING_LEFT;
            end else begin
                next_state = FALLING;
            end
        end
        WALKING_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end else begin
                next_state = WALKING_LEFT;
            end
        end
        WALKING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_LEFT;
            end else if (bump_right) begin
                next_state = WALKING_RIGHT;
            end else begin
                next_state = WALKING_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING_LEFT; // After falling, walk left
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
    endcase
end

endmodule