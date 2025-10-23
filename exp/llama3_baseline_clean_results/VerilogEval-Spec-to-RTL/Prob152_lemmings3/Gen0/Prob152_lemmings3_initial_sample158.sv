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
    WL, // Walking Left
    WR, // Walking Right
    F,  // Falling
    DL, // Digging Left
    DR  // Digging Right
} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WL: begin
            walk_left = 1'b1;
            if (~ground) begin
                next_state = F;
            end else if (dig) begin
                next_state = DL;
            end else if (bump_left) begin
                next_state = WR;
            end else if (bump_right) begin
                next_state = WL; // already in this state
            end else begin
                next_state = WL;
            end
        end
        WR: begin
            walk_right = 1'b1;
            if (~ground) begin
                next_state = F;
            end else if (dig) begin
                next_state = DR;
            end else if (bump_right) begin
                next_state = WL;
            end else if (bump_left) begin
                next_state = WR; // already in this state
            end else begin
                next_state = WR;
            end
        end
        F: begin
            aaah = 1'b1;
            if (ground) begin
                if (bump_left && bump_right) begin
                    next_state = state; // already in this state
                end else if (bump_left) begin
                    next_state = WL;
                end else if (bump_right) begin
                    next_state = WL;
                end else if (state == WL) begin
                    next_state = WL;
                end else if (state == WR) begin
                    next_state = WR;
                end else if (state == DL) begin
                    next_state = WL;
                end else if (state == DR) begin
                    next_state = WR;
                end else begin
                    next_state = F;
                end
            end else begin
                next_state = F;
            end
        end
        DL: begin
            digging = 1'b1;
            walk_left = 1'b1;
            if (~ground) begin
                next_state = F;
            end else begin
                next_state = DL;
            end
        end
        DR: begin
            digging = 1'b1;
            walk_right = 1'b1;
            if (~ground) begin
                next_state = F;
            end else begin
                next_state = DR;
            end
        end
        default: begin
            next_state = WL;
        end
    endcase
end

endmodule