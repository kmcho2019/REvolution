module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

typedef enum {LEFT, RIGHT} state;
state current_state;
state next_state;

always @(*) begin
    case(current_state)
        LEFT: begin
            if(bump_left) begin
                next_state = RIGHT;
            end else if(bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if(bump_right) begin
                next_state = LEFT;
            end else if(bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = RIGHT;
            end
        end
        default: next_state = LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= LEFT;
    end else begin
        if(bump_left || bump_right) begin
            current_state <= next_state;
        end else begin
            current_state <= current_state;
        end
    end
end

always @(*) begin
    case(current_state)
        LEFT: begin
            walk_left = 1;
            walk_right = 0;
        end
        RIGHT: begin
            walk_left = 0;
            walk_right = 1;
        end
    endcase
end

endmodule