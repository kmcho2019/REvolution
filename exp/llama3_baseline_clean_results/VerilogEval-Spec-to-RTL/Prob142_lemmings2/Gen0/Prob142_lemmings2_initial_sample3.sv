module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    output  reg     walk_left,
    output  reg     walk_right,
    output  reg     aaah
);

// Define states
enum logic [1:0] {idle_left, idle_right, falling} state, next_state;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= idle_left;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (state)
        idle_left: begin
            if (~ground) begin
                next_state = falling;
            end else if (bump_left || bump_right) begin
                next_state = idle_right;
            end else begin
                next_state = idle_left;
            end
        end
        idle_right: begin
            if (~ground) begin
                next_state = falling;
            end else if (bump_left || bump_right) begin
                next_state = idle_left;
            end else begin
                next_state = idle_right;
            end
        end
        falling: begin
            if (ground) begin
                // Keep the last direction
                if (bump_left || bump_right) begin
                    if (state == falling) begin
                        next_state = idle_left;
                    end else begin
                        next_state = idle_right;
                    end
                end else begin
                    next_state = idle_left;
                end
            end else begin
                next_state = falling;
            end
        end
        default: begin
            next_state = idle_left;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        idle_left: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        idle_right: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        falling: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
        end
    endcase
end

endmodule