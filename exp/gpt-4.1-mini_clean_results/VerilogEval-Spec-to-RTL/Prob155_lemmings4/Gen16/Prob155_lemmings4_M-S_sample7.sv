module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding:
    // 3 bits: [2]=splatter, [1:0]=mode/direction
    // mode: 00=walk left, 01=walk right, 10=dig, 11=fall
    // splatter overrides all
    reg [7:0] state, next_state; // [7:3]=fall_timer (5 bits), [2]=splatter, [1:0]=mode_dir

    // Helper signals
    wire splat = state[2];
    wire [1:0] mode_dir = state[1:0];
    wire [4:0] fall_timer = state[7:3];

    localparam 
        WALK_L = 2'b00,
        WALK_R = 2'b01,
        DIG    = 2'b10,
        FALL   = 2'b11;

    // Extract direction from mode_dir in walking and digging modes:
    // direction = 0 for left, 1 for right
    wire walking = (mode_dir == WALK_L) || (mode_dir == WALK_R);
    wire digging_mode = (mode_dir == DIG);
    wire falling_mode = (mode_dir == FALL);
    wire direction = (mode_dir == WALK_R) || (mode_dir == FALL);

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Walk left, no splatter, timer zero
            state <= {5'd0, 1'b0, WALK_L};
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        // Default: hold current
        next_state = state;

        // If splattered, remain splattered forever
        if (splat) begin
            next_state = state;
        end else begin
            // Unpack current mode and timer for convenience
            reg [4:0] ft;
            reg [2:0] mode_dir_next;
            ft = fall_timer;
            mode_dir_next = {state[2], state[1:0]}; // includes splatter, will be overwritten

            if (falling_mode) begin
                if (ground) begin
                    // Landed
                    if (ft > 5'd20) 
                        next_state = {5'd0, 1'b1, 2'b00}; // splatter (mode irrelevant)
                    else 
                        next_state = {5'd0, 1'b0, mode_dir[1] ? WALK_R : WALK_L};
                end else begin
                    // Continue falling, increment timer saturating at 31
                    if (ft < 5'd31)
                        ft = ft + 1'b1;
                    next_state = {ft, 1'b0, FALL};
                end
            end else if (digging_mode) begin
                if (!ground) begin
                    // Start falling from dig
                    next_state = {5'd1, 1'b0, FALL};
                end else begin
                    // Continue digging
                    next_state = {5'd0, 1'b0, DIG};
                end
            end else if (walking) begin
                if (!ground) begin
                    // Start falling
                    next_state = {5'd1, 1'b0, FALL};
                end else if (dig) begin
                    // Start digging
                    next_state = {5'd0, 1'b0, DIG};
                end else if (bump_left || bump_right) begin
                    // Switch direction appropriately
                    if (bump_left && bump_right)
                        next_state = {5'd0, 1'b0, direction ? WALK_L : WALK_R};
                    else if (bump_left)
                        next_state = {5'd0, 1'b0, WALK_R};
                    else // bump_right only
                        next_state = {5'd0, 1'b0, WALK_L};
                end else begin
                    // Continue walking same direction
                    next_state = {5'd0, 1'b0, mode_dir};
                end
            end else begin
                // Default fallback (should not occur), walk left
                next_state = {5'd0, 1'b0, WALK_L};
            end
        end
    end

    // Moore outputs
    assign walk_left  = (state[2:0] == {1'b0, WALK_L});
    assign walk_right = (state[2:0] == {1'b0, WALK_R});
    assign digging    = (state[2:0] == {1'b0, DIG});
    assign aaah       = (state[2:0] == {1'b0, FALL});

endmodule