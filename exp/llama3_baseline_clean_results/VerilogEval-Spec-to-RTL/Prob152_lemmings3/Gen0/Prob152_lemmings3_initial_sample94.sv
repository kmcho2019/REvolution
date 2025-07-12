module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

// State register
reg [1:0] state, next_state;

// Next state logic
always @(*) begin
    case(state)
        WALK_LEFT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end else if(bump_left) begin
                next_state = WALK_RIGHT;
            end else if(bump_right) begin
                next_state = WALK_LEFT; // Don't switch direction if bumped from right
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end else if(bump_left) begin
                next_state = WALK_LEFT;
            end else if(bump_right) begin
                next_state = WALK_LEFT; // Switch direction if bumped from right
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if(ground) begin
                // Resume walking in the same direction as before
                if(state == FALLING) begin // This means we were walking left before
                    next_state = WALK_LEFT;
                end else if(state == DIGGING) begin // This means we were digging before
                    next_state = WALK_RIGHT; // Assume we were walking right before digging
                end else begin
                    next_state = WALK_LEFT; // Default to walking left
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if(!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Output logic
always @(*) begin
    case(state)
        WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        DIGGING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        default: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

// State register update
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule