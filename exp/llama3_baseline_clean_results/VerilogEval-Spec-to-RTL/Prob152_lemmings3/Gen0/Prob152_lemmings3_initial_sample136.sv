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

reg [1:0] state; // 0: Walking Left, 1: Walking Right, 2: Falling, 3: Digging
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize to Walking Left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        0: begin // Walking Left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            if (!ground) begin
                next_state = 2; // Falling
            end else if (dig) begin
                next_state = 3; // Digging
            end else if (bump_left) begin
                next_state = 1; // Walking Right
            end else if (bump_right) begin
                next_state = 0; // Still Walking Left
            end else begin
                next_state = 0; // No change
            end
        end
        1: begin // Walking Right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            if (!ground) begin
                next_state = 2; // Falling
            end else if (dig) begin
                next_state = 3; // Digging
            end else if (bump_right) begin
                next_state = 0; // Walking Left
            end else if (bump_left) begin
                next_state = 1; // Still Walking Right
            end else begin
                next_state = 1; // No change
            end
        end
        2: begin // Falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if (ground) begin
                if (state == 0) begin
                    next_state = 0; // Resume Walking Left
                end else begin
                    next_state = 1; // Resume Walking Right
                end
            end else begin
                next_state = 2; // Continue Falling
            end
        end
        3: begin // Digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
            if (!ground) begin
                next_state = 2; // Falling
            end else begin
                next_state = 3; // Continue Digging
            end
        end
        default: begin
            next_state = 0; // Default to Walking Left
        end
    endcase
end

endmodule