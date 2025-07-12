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

    // States
    parameter WALKING = 2'd0;
    parameter FALLING = 2'd1;
    parameter DIGGING = 2'd2;

    reg [1:0] state, next_state;
    reg dir, next_dir;  // 0=left, 1=right

    // State transitions
    always @(*) begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_dir = dir;
                end
                else if (dig) begin
                    next_state = DIGGING;
                    next_dir = dir;
                end
                else if ((dir && bump_right) || (!dir && bump_left)) begin
                    next_state = WALKING;
                    next_dir = ~dir;
                end
                else begin
                    next_state = WALKING;
                    next_dir = dir;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = WALKING;
                    next_dir = dir;
                end
                else begin
                    next_state = FALLING;
                    next_dir = dir;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_dir = dir;
                end
                else begin
                    next_state = DIGGING;
                    next_dir = dir;
                end
            end
            default: begin
                next_state = WALKING;
                next_dir = 0;
            end
        endcase
    end

    // State and direction registers
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 0;
        end
        else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // Output logic
    assign walk_left = (state == WALKING) && !dir;
    assign walk_right = (state == WALKING) && dir;
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule