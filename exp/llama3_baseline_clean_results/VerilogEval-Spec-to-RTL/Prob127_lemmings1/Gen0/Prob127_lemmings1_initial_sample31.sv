module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state; // 0: walking left, 1: walking right

// Combinational logic
always @(*)
begin
    case (state)
        0: // walking left
        begin
            if (bump_left)
                walk_left = 0;
            else
                walk_left = 1;

            if (bump_left)
                walk_right = 1;
            else
                walk_right = 0;
        end
        1: // walking right
        begin
            if (bump_right)
                walk_left = 1;
            else
                walk_left = 0;

            if (bump_right)
                walk_right = 0;
            else
                walk_right = 1;
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        state <= 0; // reset to walking left
        walk_left <= 1;
        walk_right <= 0;
    end
    else
    begin
        if (bump_left && bump_right)
        begin
            state <= ~state;
        end
        else if (bump_left &&!bump_right)
        begin
            state <= 1; // walking right
        end
        else if (!bump_left && bump_right)
        begin
            state <= 0; // walking left
        end
    end
end

endmodule