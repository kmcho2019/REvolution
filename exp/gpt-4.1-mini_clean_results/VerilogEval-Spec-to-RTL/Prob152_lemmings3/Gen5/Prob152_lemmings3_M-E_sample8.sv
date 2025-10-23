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

// State encoding: 3 bits total, combining behavior and direction
localparam WL = 3'd0; // Walking Left
localparam WR = 3'd1; // Walking Right
localparam FL = 3'd2; // Falling Left
localparam FR = 3'd3; // Falling Right
localparam DL = 3'd4; // Digging Left
localparam DR = 3'd5; // Digging Right

reg [2:0] state, next_state;

// Determine if current state is walking/falling/digging and direction
wire walking = (state == WL) || (state == WR);
wire falling = (state == FL) || (state == FR);
wire digging_state = (state == DL) || (state == DR);

wire dir_left = (state == WL) || (state == FL) || (state == DL);
wire dir_right = (state == WR) || (state == FR) || (state == DR);

// Async reset + state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WL;  // Reset to walking left
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    next_state = state;

    if (falling) begin
        // Falling: if ground appears, go to walking in same direction, else keep falling
        if (ground)
            next_state = dir_left ? WL : WR;
        else
            next_state = state;
    end else if (digging_state) begin
        // Digging: if ground lost, start falling with same direction, else continue digging
        if (!ground)
            next_state = dir_left ? FL : FR;
        else
            next_state = state;
    end else if (walking) begin
        // Walking: priority fall > dig > bumps
        if (!ground) begin
            // Ground lost: start falling in current direction
            next_state = dir_left ? FL : FR;
        end else if (dig && ground) begin
            // Start digging if dig=1 and ground=1
            next_state = dir_left ? DL : DR;
        end else begin
            // Handle bumps only if on ground and walking
            if (bump_left && bump_right) begin
                // Both bumps: flip direction and stay walking
                next_state = dir_left ? WR : WL;
            end else if (bump_left) begin
                // Bump left -> walk right
                next_state = WR;
            end else if (bump_right) begin
                // Bump right -> walk left
                next_state = WL;
            end else begin
                // No bumps, keep walking same direction
                next_state = state;
            end
        end
    end else begin
        // Default: safety reset to walking left
        next_state = WL;
    end
end

// Outputs depend on current state
assign walk_left  = (state == WL);
assign walk_right = (state == WR);
assign aaah       = falling;
assign digging    = digging_state;

endmodule