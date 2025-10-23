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

    // State bits: one-hot style encoding
    localparam WALKING = 1'b0;
    localparam DIGGING = 1'b1;
    localparam FALLING = 1'b0; // We'll keep a state register encoding with an explicit bit since one-hot is trivial for three states by multiple registers, but here simpler to use a 2-bit one-hot style

    // Use a 2-bit one-hot state encoding:
    // 00: WALKING
    // 01: DIGGING
    // 10: FALLING
    // 11: (unused)
    reg [1:0] state, next_state;

    // Direction: 0=left, 1=right
    reg dir, next_dir;

    // Saved direction for falling
    reg saved_dir, next_saved_dir;

    // Synchronous update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;       // WALKING
            dir <= 1'b0;          // walk left initially
            saved_dir <= 1'b0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            saved_dir <= next_saved_dir;
        end
    end

    // Combinational next state logic
    always @* begin
        // Default assignments
        next_state = state;
        next_dir = dir;
        next_saved_dir = saved_dir;

        // Extract state signals for clarity
        wire walking = (state == 2'b00);
        wire digging = (state == 2'b01);
        wire falling = (state == 2'b10);

        if (walking) begin
            if (ground == 1'b0) begin
                // Fall immediately, save current direction
                next_state = 2'b10; // FALLING
                next_saved_dir = dir;
                // Direction remains unchanged during fall (held in saved_dir)
            end else if (dig == 1'b1) begin
                // Start digging if on ground
                next_state = 2'b01; // DIGGING
                // Direction unchanged
            end else if (bump_left | bump_right) begin
                // Switch direction if bumped left or right or both
                // Spec: bumped on left -> walk right; bumped right -> walk left; both -> switch
                // The simplest is toggle direction
                next_dir = ~dir;
                // State remains WALKING
            end
            // else stay walking same direction
        end else if (digging) begin
            if (ground == 1'b0) begin
                // Ground lost while digging: fall
                next_state = 2'b10; // FALLING
                next_saved_dir = dir;
            end
            // else remain digging same direction, bumps ignored
        end else if (falling) begin
            if (ground == 1'b1) begin
                // Landed, resume walking in saved direction
                next_state = 2'b00; // WALKING
                next_dir = saved_dir;
                // saved_dir can remain unchanged or updated to next_saved_dir=saved_dir
                // For safety, keep next_saved_dir same
                next_saved_dir = saved_dir;
            end
            // else remain falling
        end else begin
            // Defensive: unknown state, reset to walking left
            next_state = 2'b00;
            next_dir = 1'b0;
            next_saved_dir = 1'b0;
        end
    end

    // Output logic
    assign walk_left  = (state == 2'b00) && (dir == 1'b0);
    assign walk_right = (state == 2'b00) && (dir == 1'b1);
    assign digging    = (state == 2'b01);
    assign aaah       = (state == 2'b10);

endmodule