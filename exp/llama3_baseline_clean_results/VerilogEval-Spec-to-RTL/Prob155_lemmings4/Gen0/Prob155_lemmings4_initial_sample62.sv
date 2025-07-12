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

reg [4:0] fall_counter; // counter to track time spent falling
reg walk_direction; // flag to keep track of original walking direction

// states
enum logic [2:0] {WL, WR, F, D, S} state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
        walk_direction <= 1'b1;
        fall_counter <= 5'b0;
    end else begin
        state <= next_state;
        walk_direction <= walk_direction;
        if (state == F) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        WL: begin
            if (!ground) begin
                next_state = F;
            end else if (dig) begin
                next_state = D;
            end else if (bump_right) begin
                next_state = WR;
            end else if (bump_left) begin
                next_state = WL; // ignore left bump when walking left
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
                next_state = WR; // ignore right bump when walking right
            end
        end
        F: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = S;
                end else begin
                    if (walk_direction) begin
                        next_state = WL;
                    end else begin
                        next_state = WR;
                    end
                end
            end
        end
        D: begin
            if (!ground) begin
                next_state = F;
            end else begin
                next_state = D; // keep digging until ground disappears
            end
        end
        S: begin
            next_state = S; // stay in splattered state
        end
    endcase
end

always_comb begin
    walk_left = (state == WL);
    walk_right = (state == WR);
    aaah = (state == F);
    digging = (state == D);
end

endmodule