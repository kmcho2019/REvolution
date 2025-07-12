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
parameter S_WALK_LEFT = 0;
parameter S_WALK_RIGHT = 1;
parameter S_FALL = 2;
parameter S_DIG = 3;
parameter S_SPLATTER = 4;

// Define the state register
reg [2:0] state;
reg [2:0] next_state;

// Define the direction register
reg walk_dir;
reg next_walk_dir;

// Define the fall counter
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

// Output logic
assign walk_left = (state == S_WALK_LEFT) & ~areset;
assign walk_right = (state == S_WALK_RIGHT) & ~areset;
assign aaah = (state == S_FALL) & ~areset;
assign digging = (state == S_DIG) & ~areset;

// State transition logic
always @(*) begin
    next_state = state;
    next_walk_dir = walk_dir;
    next_fall_counter = fall_counter;
    
    case (state)
        S_WALK_LEFT: begin
            if (~ground) begin
                next_state = S_FALL;
            end else if (dig) begin
                next_state = S_DIG;
            end else if (bump_left) begin
                next_state = S_WALK_RIGHT;
                next_walk_dir = 1'b1;
            end else if (bump_right) begin
                next_state = S_WALK_LEFT;
                next_walk_dir = 1'b0;
            end
        end
        
        S_WALK_RIGHT: begin
            if (~ground) begin
                next_state = S_FALL;
            end else if (dig) begin
                next_state = S_DIG;
            end else if (bump_right) begin
                next_state = S_WALK_LEFT;
                next_walk_dir = 1'b0;
            end else if (bump_left) begin
                next_state = S_WALK_RIGHT;
                next_walk_dir = 1'b1;
            end
        end
        
        S_FALL: begin
            next_fall_counter = fall_counter + 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = S_SPLATTER;
                end else if (walk_dir) begin
                    next_state = S_WALK_RIGHT;
                end else begin
                    next_state = S_WALK_LEFT;
                end
                next_fall_counter = 0;
            end
        end
        
        S_DIG: begin
            if (~ground) begin
                next_state = S_FALL;
            end else if (~dig) begin
                if (walk_dir) begin
                    next_state = S_WALK_RIGHT;
                end else begin
                    next_state = S_WALK_LEFT;
                end
            end
        end
        
        S_SPLATTER: begin
            next_state = S_SPLATTER;
        end
        
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S_WALK_LEFT;
        walk_dir <= 1'b0;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        walk_dir <= next_walk_dir;
        fall_counter <= next_fall_counter;
    end
end

endmodule