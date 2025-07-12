module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state, next_state;

parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;
parameter FALLING = 2'b10;

always @(*) begin
    case(state)
        IDLE_LEFT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(bump_left) begin
                next_state = IDLE_RIGHT;
            end else if(bump_right) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(bump_left) begin
                next_state = IDLE_LEFT;
            end else if(bump_right) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if(ground) begin
                if(state == FALLING) begin
                    if(next_state == IDLE_LEFT) begin
                        next_state = IDLE_LEFT;
                    end else if(next_state == IDLE_RIGHT) begin
                        next_state = IDLE_RIGHT;
                    end else begin
                        next_state = IDLE_LEFT;
                    end
                end else begin
                    next_state = IDLE_LEFT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        default: begin
            next_state = IDLE_LEFT;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule