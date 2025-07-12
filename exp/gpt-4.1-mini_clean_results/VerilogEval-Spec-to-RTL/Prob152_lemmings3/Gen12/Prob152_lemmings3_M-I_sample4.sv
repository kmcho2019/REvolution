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

    // Mode encoding in bits [2:1]
    localparam MODE_WALK = 2'b00,
               MODE_FALL = 2'b01,
               MODE_DIG  = 2'b10;

    // State register: [2:1] = mode, [0] = direction (0=left,1=right)
    reg [2:0] state, next_state;
    wire [1:0] mode = state[2:1];
    wire       dir  = state[0];

    // Precompute bump presence and direction flip
    wire bump_any = bump_left | bump_right;
    wire flip_dir;

    // Determine if direction flips: on any bump when walking on ground
    assign flip_dir = (bump_any) && (mode == MODE_WALK) && ground;

    always @(*) begin
        // Default to hold current state
        next_state = state;

        // Priority encoding with if-else to reduce logic levels
        if (mode == MODE_WALK) begin
            if (!ground) begin
                // Fall mode takes precedence
                next_state = {MODE_FALL, dir};
            end else if (dig) begin
                // Dig mode second priority
                next_state = {MODE_DIG, dir};
            end else if (flip_dir) begin
                // Flip direction on bump(s) while walking on ground
                // New direction depends on which bump(s)
                // Both bumps or bump_left: walk right (dir=1)
                // bump_right only: walk left (dir=0)
                if (bump_left) begin
                    next_state = {MODE_WALK, 1'b1};
                end else begin
                    // Only bump_right true
                    next_state = {MODE_WALK, 1'b0};
                end
            end
            // else hold state
        end else if (mode == MODE_FALL) begin
            if (ground) begin
                // Land and resume walking same direction
                next_state = {MODE_WALK, dir};
            end
            // else keep falling
        end else if (mode == MODE_DIG) begin
            if (!ground) begin
                // Ground disappeared, switch to falling
                next_state = {MODE_FALL, dir};
            end
            // else keep digging
        end else begin
            // Defensive reset for illegal states
            next_state = {MODE_WALK, 1'b0};
        end
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= {MODE_WALK, 1'b0}; // walk left on reset
        else
            state <= next_state;
    end

    // Moore outputs decoded from state bits
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule