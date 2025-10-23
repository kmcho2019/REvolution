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

    // State encoding (2 bits)
    localparam WALKING = 2'b00;
    localparam FALLING = 2'b01;
    localparam DIGGING = 2'b10;

    reg [1:0] state, next_state;
    reg dir, next_dir;  // 0=left, 1=right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 1'b0;       // walk left on reset
        end else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    always @(*) begin
        // Default next state and direction hold
        next_state = state;
        next_dir = dir;

        case(state)
            WALKING: begin
                if (!ground) begin
                    // fall has highest priority
                    next_state = FALLING;
                    // dir unchanged
                end else if (dig) begin
                    // dig second priority
                    next_state = DIGGING;
                end else if (bump_left | bump_right) begin
                    // bump when walking on ground
                    if (bump_left & bump_right) begin
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        next_dir = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_dir = 1'b0; // walk left
                    end
                end
            end

            FALLING: begin
                if (ground) begin
                    next_state = WALKING;
                    // dir unchanged
                end
                // else remain falling
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    // dir unchanged
                end
                // else remain digging
            end

            default: begin
                next_state = WALKING;
                next_dir = 1'b0;
            end
        endcase
    end

    // Outputs: Moore outputs
    assign walk_left  = (state == WALKING) & (dir == 1'b0);
    assign walk_right = (state == WALKING) & (dir == 1'b1);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule