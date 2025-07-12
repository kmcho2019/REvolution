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

    // State encoding: [2]=digging, [1]=falling, [0]=direction (0=left, 1=right)
    // States:
    // 000 - walk left
    // 001 - walk right
    // 010 - fall left
    // 011 - fall right
    // 100 - dig left
    // 101 - dig right

    reg [2:0] state, next_state;
    reg prev_ground;

    wire digging_flag = state[2];
    wire falling_flag = state[1];
    wire direction    = state[0]; // 0=left, 1=right

    // Detect stable ground (ground stable high for 2 cycles)
    wire stable_ground = ground & prev_ground;

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        if (falling_flag) begin
            // Falling: remain falling until ground=1, then resume walking same direction
            if (ground)
                next_state = {1'b0, 1'b0, direction}; // walk state (dig=0, fall=0, direction)
            else
                next_state = state; // keep falling
        end
        else if (digging_flag) begin
            // Digging: remain digging while ground=1, else start falling
            if (!ground)
                next_state = {1'b0, 1'b1, direction}; // fall state, same direction
            else
                next_state = state; // keep digging
        end
        else begin
            // Walking states
            if (!ground) begin
                // ground disappeared: start falling immediately, ignore bumps/dig this cycle
                next_state = {1'b0, 1'b1, direction}; // fall
            end
            else if (dig && stable_ground) begin
                // Start digging if requested and on stable ground
                next_state = {1'b1, 1'b0, direction}; // dig
            end
            else if (stable_ground && (bump_left || bump_right)) begin
                // Bump logic:
                // Both bumps -> toggle direction
                if (bump_left && bump_right) begin
                    next_state = {1'b0, 1'b0, ~direction};
                end
                // Only bump_left -> walk right (direction=1)
                else if (bump_left) begin
                    next_state = {1'b0, 1'b0, 1'b1};
                end
                // Only bump_right -> walk left (direction=0)
                else begin
                    next_state = {1'b0, 1'b0, 1'b0};
                end
            end
            else begin
                // No change - keep walking same direction
                next_state = state;
            end
        end
    end

    // Sequential state update + prev_ground register for stable ground detection
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 3'b000;    // walk left (dig=0, fall=0, dir=0)
            prev_ground <= 1'b1; // assume initially on ground stable
        end
        else begin
            state <= next_state;
            prev_ground <= ground;
        end
    end

    // Output decoding (Moore FSM)
    assign walk_left  = (state == 3'b000) || (state == 3'b010) || (state == 3'b100) ? (state[1:2] == 2'b00 || state[2] == 1'b1) && !falling_flag && !digging_flag && (direction == 0) : 1'b0;
    assign walk_left  = (!falling_flag && !digging_flag && (direction == 1'b0));

    assign walk_right = (!falling_flag && !digging_flag && (direction == 1'b1));
    assign aaah       = falling_flag;
    assign digging    = digging_flag;

endmodule