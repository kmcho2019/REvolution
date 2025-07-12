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
enum logic [1:0] {WL, WR, F, D} state, next_state;

// Output logic
always_comb begin
    walk_left = (state == WL);
    walk_right = (state == WR);
    aaah = (state == F);
    digging = (state == D);
end

// Next state logic
always_comb begin
    next_state = state;

    case (state)
        WL: begin
            if (!ground) begin
                next_state = F;
            end else if (bump_left) begin
                next_state = WR;
            end else if (dig) begin
                next_state = D;
            end else if (bump_right) begin
                next_state = WR;
            end
        end

        WR: begin
            if (!ground) begin
                next_state = F;
            end else if (bump_right) begin
                next_state = WL;
            end else if (dig) begin
                next_state = D;
            end else if (bump_left) begin
                next_state = WL;
            end
        end

        F: begin
            if (ground) begin
                next_state = (walk_left) ? WL : WR;
            end
        end

        D: begin
            if (!ground) begin
                next_state = F;
            end
        end

        default: next_state = WL;
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
    end else begin
        state <= next_state;
    end
end

endmodule