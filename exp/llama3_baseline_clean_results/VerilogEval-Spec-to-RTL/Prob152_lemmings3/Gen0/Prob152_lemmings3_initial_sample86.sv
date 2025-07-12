module TopModule (
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

// Enumerate the states
typedef enum {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIG_LEFT,
    DIG_RIGHT
} state_t;

// Current state and next state
state_t cs, ns;

// Output logic
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (cs)
        WALK_LEFT: begin
            walk_left = 1;
            if (dig) begin
                digging = 1;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (dig) begin
                digging = 1;
            end
        end
        FALLING: begin
            aaah = 1;
        end
        DIG_LEFT: begin
            walk_left = 1;
            digging = 1;
        end
        DIG_RIGHT: begin
            walk_right = 1;
            digging = 1;
        end
    endcase
end

// Next state logic
always_comb begin
    case (cs)
        WALK_LEFT: begin
            if (!ground) begin
                ns = FALLING;
            end else if (bump_left) begin
                ns = WALK_RIGHT;
            end else if (bump_right) begin
                ns = WALK_LEFT;
            end else if (dig) begin
                ns = DIG_LEFT;
            end else begin
                ns = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                ns = FALLING;
            end else if (bump_left) begin
                ns = WALK_LEFT;
            end else if (bump_right) begin
                ns = WALK_RIGHT;
            end else if (dig) begin
                ns = DIG_RIGHT;
            end else begin
                ns = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (bump_left) begin
                    ns = WALK_RIGHT;
                end else if (bump_right) begin
                    ns = WALK_LEFT;
                end else if (dig) begin
                    ns = WALK_LEFT;
                end else if (cs == FALLING) begin
                    if (bump_left) begin
                        ns = WALK_RIGHT;
                    end else if (bump_right) begin
                        ns = WALK_LEFT;
                    end else begin
                        if (bump_left && bump_right) begin
                            ns = WALK_LEFT;
                        end else begin
                            if (bump_left) begin
                                ns = WALK_RIGHT;
                            end else if (bump_right) begin
                                ns = WALK_LEFT;
                            end else begin
                                if (dig) begin
                                    ns = WALK_LEFT;
                                end else begin
                                    ns = WALK_LEFT;
                                end
                            end
                        end
                    end
                end else begin
                    if (cs == WALK_LEFT) begin
                        ns = WALK_LEFT;
                    end else begin
                        ns = WALK_RIGHT;
                    end
                end
            end else begin
                ns = FALLING;
            end
        end
        DIG_LEFT: begin
            if (!ground) begin
                ns = FALLING;
            end else begin
                ns = WALK_LEFT;
            end
        end
        DIG_RIGHT: begin
            if (!ground) begin
                ns = FALLING;
            end else begin
                ns = WALK_RIGHT;
            end
        end
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        cs <= WALK_LEFT;
    end else begin
        cs <= ns;
    end
end

endmodule