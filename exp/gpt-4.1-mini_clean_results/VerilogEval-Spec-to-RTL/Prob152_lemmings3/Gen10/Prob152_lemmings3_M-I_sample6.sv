module TopModule(
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

// One-hot state encoding for clarity and timing
localparam WALKING = 3'b001;
localparam FALLING = 3'b010;
localparam DIGGING = 3'b100;

// State registers
reg [2:0] state, next_state;

// Direction register: 0 = left, 1 = right
reg dir, next_dir;

// To minimize toggling of prev_ground, latch only when ground=1
reg prev_ground_sync;

wire stable_ground = (ground == 1'b1) && (prev_ground_sync == 1'b1);

// Synchronize prev_ground only when ground=1 to reduce toggling
always @(posedge clk) begin
    if (areset) begin
        prev_ground_sync <= 1'b1;
    end else if (ground) begin
        prev_ground_sync <= ground;
    end
    // else hold prev_ground_sync value to prevent toggling when ground=0
end

// Combinational next-state and next-dir logic
always @(*) begin
    // Default hold
    next_state = state;
    next_dir = dir;

    case (state)
        WALKING: begin
            // Priority: fall > dig > bump > hold
            if (!ground) begin
                // Fall immediately
                next_state = FALLING;
                // dir unchanged
            end else if (dig && stable_ground) begin
                next_state = DIGGING;
                // dir unchanged
            end else if (stable_ground && (bump_left || bump_right)) begin
                // bump logic
                if (bump_left && bump_right) begin
                    next_dir = ~dir; // toggle
                end else if (bump_left) begin
                    next_dir = 1'b1; // walk right
                end else /* bump_right only */ begin
                    next_dir = 1'b0; // walk left
                end
                // stay walking
                next_state = WALKING;
            end
            // else hold walking and dir
        end

        FALLING: begin
            // Stay falling until ground returns
            if (ground) begin
                next_state = WALKING;
                // dir unchanged
            end
            // else hold falling
        end

        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                // dir unchanged
            end
            // else hold digging
        end

        default: begin
            // safe fallback
            next_state = WALKING;
            next_dir = 1'b0;
        end
    endcase
end

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (areset) begin
        state <= WALKING;
        dir <= 1'b0; // walk left on reset
    end else begin
        state <= next_state;
        dir <= next_dir;
    end
end

// Outputs (Moore machine)
assign walk_left  = (state == WALKING) && (dir == 1'b0);
assign walk_right = (state == WALKING) && (dir == 1'b1);
assign aaah       = (state == FALLING);
assign digging    = (state == DIGGING);

endmodule