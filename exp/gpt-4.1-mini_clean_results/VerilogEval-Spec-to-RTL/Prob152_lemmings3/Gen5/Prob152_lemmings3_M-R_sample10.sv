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

    // State type encoding
    localparam WALKING = 2'd0;
    localparam FALLING = 2'd1;
    localparam DIGGING = 2'd2;

    reg [1:0] state_type, next_state_type;
    reg dir, next_dir; // 0=left, 1=right

    reg prev_ground;

    // Update prev_ground on every clock edge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            prev_ground <= 1'b1; // Assume starts on ground
        end else begin
            prev_ground <= ground;
        end
    end

    // State type update (Moore FSM)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_type <= WALKING;
        end else begin
            state_type <= next_state_type;
        end
    end

    // Direction update, only changes in walking state on bumps when stable ground
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir <= 1'b0; // walk left on reset
        end else begin
            dir <= next_dir;
        end
    end

    // Stable ground: ground steady at 1
    wire stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);

    // Next-state and next-direction combinational logic
    always @(*) begin
        // Defaults
        next_state_type = state_type;
        next_dir = dir;

        case(state_type)
            WALKING: begin
                // Priority: fall > dig > bump direction

                // Falling condition
                if (ground == 1'b0) begin
                    next_state_type = FALLING;
                    // Direction unchanged while falling
                end
                // Dig condition: dig asserted and stable ground
                else if (dig && stable_ground) begin
                    next_state_type = DIGGING;
                end
                // Bump condition with stable ground
                else if (stable_ground && (bump_left || bump_right)) begin
                    // Both bumps: toggle direction
                    if (bump_left && bump_right) begin
                        next_dir = ~dir;
                    end
                    // Only bump_left: walk right (dir=1)
                    else if (bump_left) begin
                        next_dir = 1'b1;
                    end
                    // Only bump_right: walk left (dir=0)
                    else begin
                        next_dir = 1'b0;
                    end
                end
                // Else maintain walking and direction
                else begin
                    next_dir = dir;
                end
            end

            FALLING: begin
                // Stay falling until ground returns
                if (ground == 1'b1) begin
                    next_state_type = WALKING;
                    // direction unchanged
                end
                // else remain falling
            end

            DIGGING: begin
                // Stay digging while ground=1, else fall
                if (ground == 1'b0) begin
                    next_state_type = FALLING;
                end
            end

            default: begin
                // Safety fallback
                next_state_type = WALKING;
                next_dir = 1'b0;
            end
        endcase
    end

    // Outputs (Moore style)
    assign walk_left  = (state_type == WALKING) && (dir == 1'b0);
    assign walk_right = (state_type == WALKING) && (dir == 1'b1);
    assign aaah       = (state_type == FALLING);
    assign digging    = (state_type == DIGGING);

endmodule