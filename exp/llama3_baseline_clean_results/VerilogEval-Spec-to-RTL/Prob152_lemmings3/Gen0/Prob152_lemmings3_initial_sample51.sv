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

// Define the states
enum logic [2:0] {
    idle_left,
    idle_right,
    falling,
    digging_left,
    digging_right
} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= idle_left;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (state)
        idle_left: begin
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_left;
            end else if (bump_left) begin
                next_state = idle_right;
            end else if (bump_right) begin
                next_state = idle_left;
            end else begin
                next_state = idle_left;
            end
        end
        idle_right: begin
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_right;
            end else if (bump_right) begin
                next_state = idle_left;
            end else if (bump_left) begin
                next_state = idle_right;
            end else begin
                next_state = idle_right;
            end
        end
        falling: begin
            if (ground) begin
                if (state == falling && (bump_left || bump_right)) begin
                    if (state == falling && bump_left) begin
                        next_state = idle_right;
                    end else if (state == falling && bump_right) begin
                        next_state = idle_left;
                    end else begin
                        next_state = idle_left;
                    end
                end else if (state == falling && dig) begin
                    next_state = idle_left;
                end else begin
                    next_state = idle_left;
                end
            end else begin
                next_state = falling;
            end
        end
        digging_left: begin
            if (!ground) begin
                next_state = falling;
            end else begin
                next_state = digging_left;
            end
        end
        digging_right: begin
            if (!ground) begin
                next_state = falling;
            end else begin
                next_state = digging_right;
            end
        end
        default: begin
            next_state = idle_left;
        end
    endcase
end

// Output logic
always_comb begin
    case (state)
        idle_left: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        idle_right: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        falling: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        digging_left: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        digging_right: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule