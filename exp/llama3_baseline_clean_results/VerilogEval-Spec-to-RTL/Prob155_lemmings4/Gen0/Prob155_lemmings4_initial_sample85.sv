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

// Enum for states
enum logic [2:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Register to store the current state
logic [2:0] state_reg;

// Register to store the direction before falling or digging
logic direction;

// Counter for falling cycles
logic [5:0] fall_counter;

// Outputs based on current state
always_comb begin
    walk_left = (state_reg == IDLE_LEFT);
    walk_right = (state_reg == IDLE_RIGHT);
    aaah = (state_reg == FALLING);
    digging = (state_reg == DIGGING);
end

// Next state logic
always_comb begin
    next_state = state_reg;
    
    case (state_reg)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                if (bump_left) begin
                    next_state = IDLE_RIGHT;
                end else begin
                    next_state = IDLE_LEFT;
                end
            end
        end
        
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                if (bump_right) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end
        end
        
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (direction) begin
                        next_state = IDLE_LEFT;
                    end else begin
                        next_state = IDLE_RIGHT;
                    end
                end
            end
        end
        
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (ground && !dig) begin
                if (direction) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end
        end
        
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        
        default: next_state = IDLE_LEFT;
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= IDLE_LEFT;
        direction <= 1'b1;
        fall_counter <= 6'b0;
    end else begin
        case (state_reg)
            IDLE_LEFT: begin
                direction <= 1'b1;
            end
            
            IDLE_RIGHT: begin
                direction <= 1'b0;
            end
            
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
            end
            
            DIGGING: begin
                // No action
            end
            
            SPLATTERED: begin
                // No action
            end
            
            default: begin
                // No action
            end
        endcase
        
        state_reg <= next_state;
    end
end

// Assign initial state
initial begin
    state_reg = IDLE_LEFT;
end

endmodule