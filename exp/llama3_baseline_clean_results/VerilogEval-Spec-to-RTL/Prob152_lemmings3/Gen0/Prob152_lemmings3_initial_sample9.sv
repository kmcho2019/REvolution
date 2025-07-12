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
enum logic [1:0] {
    WALK_LEFT = 2'b00,
    WALK_RIGHT = 2'b01,
    FALL = 2'b10,
    DIG = 2'b11
} state, next_state;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALL;
            end else if (dig == 1'b1) begin
                next_state = DIG;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_RIGHT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALL;
            end else if (dig == 1'b1) begin
                next_state = DIG;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_LEFT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        
        FALL: begin
            aaah = 1'b1;
            if (ground == 1'b1) begin
                if (state == FALL) begin
                    if (walk_left == 1'b1) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = state;
                end
            end else begin
                next_state = FALL;
            end
        end
        
        DIG: begin
            digging = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALL;
            end else begin
                next_state = DIG;
            end
        end
        
        default: next_state = WALK_LEFT;
    endcase
end

endmodule