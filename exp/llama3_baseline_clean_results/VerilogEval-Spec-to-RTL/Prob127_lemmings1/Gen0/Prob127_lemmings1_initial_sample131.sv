module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] current_state;
reg [1:0] next_state;

parameter WALK_LEFT = 2'b01;
parameter WALK_RIGHT = 2'b10;

always @ (posedge areset or posedge clk) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
    
    if (bump_left && bump_right) begin
        case (current_state)
            WALK_LEFT: begin
                next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                next_state = WALK_LEFT;
            end
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end
end

always @ (*) begin
    case (current_state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

endmodule