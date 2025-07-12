module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Enum for states
enum logic [1:0] {
    WL, // Walking Left
    WR, // Walking Right
    F,  // Falling
    D   // Digging
} state, next_state;

// Signal to keep track of the direction
logic [1:0] direction;

// Assign outputs based on the state
always_comb begin
    case (state)
        WL: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WR: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        F: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        D: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

// State transitions
always_comb begin
    case (state)
        WL: begin
            if (!ground) begin
                next_state = F;
            end else if (dig) begin
                next_state = D;
            end else if (bump_left) begin
                next_state = WR;
            end else if (bump_right) begin
                next_state = WL;
            end else begin
                next_state = WL;
            end
        end
        WR: begin
            if (!ground) begin
                next_state = F;
            end else if (dig) begin
                next_state = D;
            end else if (bump_left) begin
                next_state = WL;
            end else if (bump_right) begin
                next_state = WR;
            end else begin
                next_state = WR;
            end
        end
        F: begin
            if (ground) begin
                if (direction == 2'b00) begin
                    next_state = WL;
                end else begin
                    next_state = WR;
                end
            end else begin
                next_state = F;
            end
        end
        D: begin
            if (!ground) begin
                next_state = F;
            end else begin
                next_state = D;
            end
        end
    endcase
end

// Update state and direction
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
        direction <= 2'b00;
    end else begin
        if (state == F) begin
            if (direction == 2'b00) begin
                direction <= 2'b00;
            end else begin
                direction <= 2'b01;
            end
        end else if (state == WL) begin
            direction <= 2'b00;
        end else if (state == WR) begin
            direction <= 2'b01;
        end else if (state == D) begin
            if (direction == 2'b00) begin
                direction <= 2'b00;
            end else begin
                direction <= 2'b01;
            end
        end
        state <= next_state;
    end
end

endmodule