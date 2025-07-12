module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding
    localparam WALK_LEFT  = 3'b001;
    localparam WALK_RIGHT = 3'b010;
    localparam FALLING    = 3'b100;

    reg [2:0] state, next_state;
    reg last_dir; // 0 = left, 1 = right

    // Next state logic
    always @* begin
        next_state = state; // default hold
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling, remember direction left
                    next_state = FALLING;
                end else if (bump_left || (bump_left && bump_right)) begin
                    // bumped left, go right
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // bumped right, stay left (no change since walking left)
                    // But spec says bump_right means walk left, so direction stays left here.
                    // Actually, bumped right should cause walk left, which is current state, so no change
                    next_state = WALK_LEFT;
                end
                // else stay walk left
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    // Start falling, remember direction right
                    next_state = FALLING;
                end else if (bump_right || (bump_left && bump_right)) begin
                    // bumped right, go left
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    // bumped left, stay right (no change since walking right)
                    // bumped left means walk right, which is current state, no change
                    next_state = WALK_RIGHT;
                end
                // else stay walk right
            end
            FALLING: begin
                if (ground) begin
                    // ground reappears, resume walking in last_dir direction
                    next_state = last_dir ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    // keep falling
                    next_state = FALLING;
                end
            end
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    // last_dir update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            last_dir <= 1'b0; // start walking left
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (bump_left || (bump_left && bump_right))
                        last_dir <= 1'b1; // bumped left -> walk right
                    else if (bump_right)
                        last_dir <= 1'b0; // bumped right -> walk left (already left)
                    else
                        last_dir <= 1'b0; // keep left
                end
                WALK_RIGHT: begin
                    if (bump_right || (bump_left && bump_right))
                        last_dir <= 1'b0; // bumped right -> walk left
                    else if (bump_left)
                        last_dir <= 1'b1; // bumped left -> walk right (already right)
                    else
                        last_dir <= 1'b1; // keep right
                end
                FALLING: begin
                    // keep last_dir unchanged during falling
                    last_dir <= last_dir;
                end
                default: begin
                    last_dir <= 1'b0;
                end
            endcase
        end
    end

    // State register update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output decoding (Moore outputs)
    assign aaah       = (state == FALLING);
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule