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

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;
parameter SPLATTERED = 2'b10; // Overlap with FALLING, but handled separately

// Internal state and output registers
reg [1:0] state;
reg [1:0] nextState;
reg [4:0] fall_count;
reg walking_left;

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
        default: begin // SPLATTERED
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                nextState = FALLING;
            end else if (dig &&!bump_left &&!bump_right) begin
                nextState = DIGGING;
            end else if (bump_left || (bump_left && bump_right)) begin
                nextState = WALK_RIGHT;
            end else if (bump_right) begin
                nextState = WALK_RIGHT;
            end else begin
                nextState = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                nextState = FALLING;
            end else if (dig &&!bump_left &&!bump_right) begin
                nextState = DIGGING;
            end else if (bump_right || (bump_left && bump_right)) begin
                nextState = WALK_LEFT;
            end else if (bump_left) begin
                nextState = WALK_LEFT;
            end else begin
                nextState = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 20) begin
                    nextState = SPLATTERED;
                end else begin
                    nextState = walking_left? WALK_LEFT : WALK_RIGHT;
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
        default: begin // SPLATTERED
            nextState = SPLATTERED;
        end
    endcase
end

// State and fall count registers
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
        walking_left <= 1'b1;
    end else begin
        case (state)
            FALLING: begin
                fall_count <= fall_count + 1;
            end
            WALK_LEFT: begin
                walking_left <= 1'b1;
            end
            WALK_RIGHT: begin
                walking_left <= 1'b0;
            end
            default: begin
                fall_count <= 0;
            end
        endcase
        state <= nextState;
    end
end

endmodule