module TopModule (
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

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

reg [1:0] state, next_state;

// Output logic
always @(state) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == DIGGING) ? 1'b1 : 1'b0;

// Next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    if (dig) begin
                        next_state <= DIGGING;
                    end else begin
                        next_state <= FALLING;
                    end
                end else if (bump_left) begin
                    next_state <= WALK_RIGHT;
                end else if (dig) begin
                    next_state <= DIGGING;
                end else begin
                    next_state <= WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    if (dig) begin
                        next_state <= DIGGING;
                    end else begin
                        next_state <= FALLING;
                    end
                end else if (bump_right) begin
                    next_state <= WALK_LEFT;
                end else if (dig) begin
                    next_state <= DIGGING;
                end else begin
                    next_state <= WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state <= state == DIGGING ? WALK_LEFT : (state == WALK_RIGHT ? WALK_RIGHT : WALK_LEFT);
                end else begin
                    next_state <= FALLING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state <= FALLING;
                end else begin
                    next_state <= DIGGING;
                end
            end
            default: begin
                next_state <= WALK_LEFT;
            end
        endcase
        state <= next_state;
    end
end

endmodule