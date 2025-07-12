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
    parameter WALK = 2'd0;
    parameter FALL = 2'd1;
    parameter DIG = 2'd2;

    reg [1:0] state, next_state;
    reg dir, next_dir;  // 0 for left, 1 for right

    // State transition logic
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL;
                    next_dir = dir;
                end
                else if (dig) begin
                    next_state = DIG;
                    next_dir = dir;
                end
                else begin
                    next_state = WALK;
                    // Update direction only when walking and not falling/digging
                    if (bump_left && !bump_right) next_dir = 1'b1;
                    else if (bump_right && !bump_left) next_dir = 1'b0;
                    else if (bump_left && bump_right) next_dir = ~dir;
                    else next_dir = dir;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = WALK;
                    next_dir = dir;
                end
                else begin
                    next_state = FALL;
                    next_dir = dir;
                end
            end
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                    next_dir = dir;
                end
                else begin
                    next_state = DIG;
                    next_dir = dir;
                end
            end
            default: begin
                next_state = WALK;
                next_dir = 1'b0;
            end
        endcase
    end

    // State and direction registers with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0;  // Start walking left
        end
        else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~dir;
    assign walk_right = (state == WALK) & dir;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule