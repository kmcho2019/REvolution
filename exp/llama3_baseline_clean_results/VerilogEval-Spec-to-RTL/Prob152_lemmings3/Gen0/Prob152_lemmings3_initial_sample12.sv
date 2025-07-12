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

// Define the states
reg [1:0] state;
reg [1:0] nextState;

// Define the state encoding
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// Initialize the state
initial state = WALK_LEFT;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                nextState = FALLING;
            end else if (dig) begin
                nextState = DIGGING;
            end else if (bump_left) begin
                nextState = WALK_RIGHT;
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
            end else begin
                nextState = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                // If the Lemming was digging, it will resume walking in the same direction
                // If the Lemming was not digging, it will resume walking in the same direction
                if (nextState == DIGGING) begin
                    nextState = WALK_LEFT;
                end else if (nextState == WALK_RIGHT) begin
                    nextState = WALK_RIGHT;
                end else if (dig) begin
                    nextState = DIGGING;
                end else if (bump_left) begin
                    nextState = WALK_RIGHT;
                end else if (bump_right) begin
                    nextState = WALK_LEFT;
                end else begin
                    nextState = WALK_LEFT;
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

// Output logic
always @(*) begin
    case (state)
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

endmodule