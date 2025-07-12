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

    // State encoding (3 bits)
    localparam WLK_L = 3'd0;
    localparam WLK_R = 3'd1;
    localparam FAL_L = 3'd2;
    localparam FAL_R = 3'd3;
    localparam DIG_L = 3'd4;
    localparam DIG_R = 3'd5;

    reg [2:0] state, next_state;

    always @(*) begin
        next_state = state;
        case(state)
            WLK_L: begin
                if (!ground)
                    next_state = FAL_L;
                else if (dig)
                    next_state = DIG_L;
                else if (bump_left || bump_right) begin
                    // switch direction on bump
                    if (bump_left && bump_right)
                        next_state = WLK_R;
                    else if (bump_left)
                        next_state = WLK_R;
                    else // bump_right
                        next_state = WLK_L;
                    // Note: bump_right causes walk left, bump_left causes walk right
                end
            end
            WLK_R: begin
                if (!ground)
                    next_state = FAL_R;
                else if (dig)
                    next_state = DIG_R;
                else if (bump_left || bump_right) begin
                    if (bump_left && bump_right)
                        next_state = WLK_L;
                    else if (bump_left)
                        next_state = WLK_R;
                    else // bump_right
                        next_state = WLK_L;
                end
            end
            DIG_L: begin
                if (!ground)
                    next_state = FAL_L;
                else
                    next_state = DIG_L;
            end
            DIG_R: begin
                if (!ground)
                    next_state = FAL_R;
                else
                    next_state = DIG_R;
            end
            FAL_L: begin
                if (ground)
                    next_state = WLK_L;
                else
                    next_state = FAL_L;
            end
            FAL_R: begin
                if (ground)
                    next_state = WLK_R;
                else
                    next_state = FAL_R;
            end
            default: next_state = WLK_L;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WLK_L;
        else
            state <= next_state;
    end

    assign walk_left  = (state == WLK_L);
    assign walk_right = (state == WLK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FAL_L) || (state == FAL_R);

endmodule