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

    // State bits:
    // dir: 0=left, 1=right
    // on_ground: 1=walking, 0=falling
    reg dir;          // current walking direction
    reg on_ground;    // ground presence flag

    wire bump = bump_left | bump_right;

    // Next state logic combinational signals
    reg next_dir;
    reg next_on_ground;

    always @(*) begin
        // Default to current state
        next_dir = dir;
        next_on_ground = on_ground;

        if (on_ground) begin
            // If on ground and bumped on either side, flip direction
            if (bump)
                next_dir = ~dir;

            // If ground disappears, start falling (on_ground=0)
            if (!ground)
                next_on_ground = 1'b0;
            else
                next_on_ground = 1'b1;
        end else begin
            // Falling state: stay falling if no ground
            if (ground)
                next_on_ground = 1'b1; // land, resume walking same direction
            else
                next_on_ground = 1'b0;
            // Direction unchanged during fall
            next_dir = dir;
        end
    end

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir <= 1'b0;        // reset to walk left
            on_ground <= 1'b1;  // reset to on ground (walking)
        end else begin
            dir <= next_dir;
            on_ground <= next_on_ground;
        end
    end

    // Output assignments based on Moore outputs
    assign walk_left  = on_ground & (~dir);
    assign walk_right = on_ground & dir;
    assign aaah       = ~on_ground;

endmodule