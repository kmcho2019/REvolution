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

// State encoding
parameter WL = 2'b00; // Walking Left
parameter WR = 2'b01; // Walking Right
parameter F = 2'b10;  // Falling
parameter DL = 2'b11; // Digging Left
parameter DR = 2'b10; // This state will not be used, instead we will use the F state for digging right

reg [1:0] state, next_state;
reg prev_walk_dir;

always @(*) begin
    next_state = state;
    case (state)
        WL: begin
            if (!ground) next_state = F;
            else if (dig) next_state = DL;
            else if (bump_left) next_state = WR;
            else if (bump_right) next_state = WL;
        end
        WR: begin
            if (!ground) next_state = F;
            else if (dig) next_state = DR; // Set next state as F (for digging right)
            else if (bump_left) next_state = WL;
            else if (bump_right) next_state = WR;
        end
        F: begin
            if (ground) next_state = prev_walk_dir ? WL : WR;
        end
        DL: begin
            if (!ground) next_state = F;
        end
        default: begin // DR state
            next_state = F; // Since we are digging right, we will transition to F state
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
        prev_walk_dir <= 1'b1; // Initialize prev_walk_dir as walking left
    end else begin
        state <= next_state;
        if (state == WL || state == DL) prev_walk_dir <= 1'b1; // Update prev_walk_dir
        else if (state == WR || state == DR) prev_walk_dir <= 1'b0;
    end
end

always @(*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    case (state)
        WL: begin
            walk_left = 1'b1;
        end
        WR: begin
            walk_right = 1'b1;
        end
        F: begin
            aaah = 1'b1;
        end
        DL: begin
            walk_left = 1'b1;
            digging = 1'b1;
        end
        default: begin // DR state
            walk_right = 1'b1;
            digging = 1'b1;
        end
    endcase
end

endmodule