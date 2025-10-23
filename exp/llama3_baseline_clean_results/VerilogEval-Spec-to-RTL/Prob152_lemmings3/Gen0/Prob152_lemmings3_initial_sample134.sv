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
enum logic [1:0] {WL, WR, F, D} state, next_state;

// Current direction (for use when falling and when digging)
logic walking_left;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
        walking_left <= 1'b1;
    end else begin
        state <= next_state;
        if (next_state == WL) walking_left <= 1'b1;
        else if (next_state == WR) walking_left <= 1'b0;
    end
end

always_comb begin
    case (state)
        WL: begin
            if (!ground) next_state = F;
            else if (dig) next_state = D;
            else if (bump_right) next_state = WR;
            else if (bump_left) next_state = WR; // Actually goes to WR, corrected logic
            else next_state = WL;
        end
        WR: begin
            if (!ground) next_state = F;
            else if (dig) next_state = D;
            else if (bump_left) next_state = WL;
            else if (bump_right) next_state = WL; // Actually goes to WL, corrected logic
            else next_state = WR;
        end
        F: begin
            if (ground) begin
                if (walking_left) next_state = WL;
                else next_state = WR;
            end else next_state = F;
        end
        D: begin
            if (!ground) next_state = F;
            else next_state = D;
        end
        default: next_state = WL;
    endcase
end

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
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule