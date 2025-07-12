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

// Enumerations for the states
enum logic [1:0] {
    WALK_LEFT = 2'b00,
    WALK_RIGHT = 2'b01,
    FALL = 2'b10,
    DIG = 2'b11
} state, next_state;

// Registers to store the current state and the previous direction
logic walk_left_reg;
logic walk_right_reg;

// Combinational logic to determine the next state and the outputs
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (~ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (~ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        
        FALL: begin
            aaah = 1'b1;
            if (ground) begin
                if (walk_left_reg) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
        end
        
        DIG: begin
            digging = 1'b1;
            if (~ground) begin
                next_state = FALL;
            end
        end
        
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Sequential logic to update the state and the previous direction
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_left_reg <= 1'b1;
        walk_right_reg <= 1'b0;
    end else begin
        state <= next_state;
        if (state == WALK_LEFT) begin
            walk_left_reg <= 1'b1;
            walk_right_reg <= 1'b0;
        end else if (state == WALK_RIGHT) begin
            walk_left_reg <= 1'b0;
            walk_right_reg <= 1'b1;
        end
    end
end

endmodule