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
    reg prev_ground;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 1'b0;       // walk left on reset
            prev_ground <= 1'b1;
        end else begin
            state <= next_state;
            dir <= next_dir;
            prev_ground <= ground;
        end
    end

    wire stable_ground = ground & prev_ground;

    always @(*) begin
        // Default next state and direction hold
        next_state = state;
        next_dir = dir;

        case(state)
            WALKING: begin
                if (!ground) begin
                    // Fall has highest priority
                    next_state = FALLING;
                    // Direction unchanged while falling
                end else if (dig & stable_ground) begin
                    // Dig has second priority
                    next_state = DIGGING;
                end else if (stable_ground & (bump_left | bump_right)) begin
                    // Bump logic:
                    if (bump_left & bump_right) begin
                        next_dir = ~dir; // Both bumps: toggle direction
                    end else if (bump_left) begin
                        next_dir = 1'b1; // bump_left: walk right
                    end else if (bump_right) begin
                        next_dir = 1'b0; // bump_right: walk left
                    end
                    // remain walking
                end
                // else keep walking same direction
            end

            FALLING: begin
                if (ground) begin
                    next_state = WALKING;
                    // resume walking same direction
                end
                // else remain falling
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    // direction unchanged
                end
                // else remain digging
            end

            default: begin
                next_state = WALKING;
                next_dir = 1'b0;
            end
        endcase
    end

    // Outputs: Moore machine outputs depend on state and direction
    assign walk_left  = (state == WALKING) & (dir == 1'b0);
    assign walk_right = (state == WALKING) & (dir == 1'b1);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule