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

// Enumerate the states
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING} state, next_state;

// Initialize the state machine
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= IDLE_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        case(state)
            IDLE_LEFT: begin
                if(!ground) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end else if(dig) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    digging <= 1'b1;
                end else if(bump_left) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end
            end
            IDLE_RIGHT: begin
                if(!ground) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end else if(dig) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    digging <= 1'b1;
                end else if(bump_right) begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            FALLING: begin
                if(ground) begin
                    aaah <= 1'b0;
                    if(state == IDLE_LEFT) begin
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else if(state == IDLE_RIGHT) begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                end
            end
            DIGGING: begin
                if(!ground) begin
                    digging <= 1'b0;
                    aaah <= 1'b1;
                end
            end
        endcase
    end
end

// Determine the next state
always_comb begin
    case(state)
        IDLE_LEFT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end else if(bump_left) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end else if(bump_right) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if(ground) begin
                if(bump_left) begin
                    next_state = IDLE_RIGHT;
                end else if(bump_right) begin
                    next_state = IDLE_LEFT;
                end else if(dig) begin
                    next_state = DIGGING;
                end else if(state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                end else if(state == IDLE_RIGHT) begin
                    next_state = IDLE_RIGHT;
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
    endcase
end

endmodule