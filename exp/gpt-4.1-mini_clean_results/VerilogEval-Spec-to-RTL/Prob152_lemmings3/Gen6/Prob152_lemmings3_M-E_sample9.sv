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

// State encoding (3 bits total)
// Bit0 = walk_left active
// Bit1 = walk_right active
// Bit2 = digging (1) or falling (1)
// We'll encode states as follows:
//
// WALK_LEFT       = 3'b001 (bit0=1, bit1=0, bit2=0)
// WALK_RIGHT      = 3'b010 (bit0=0, bit1=1, bit2=0)
// DIGGING_LEFT   = 3'b101 (bit0=1, bit1=0, bit2=1)
// DIGGING_RIGHT  = 3'b110 (bit0=0, bit1=1, bit2=1)
// FALLING_LEFT    = 3'b001 + fall_flag = 3'b101 (reuse DIGGING_LEFT with digging=falling flag? No, to avoid confusion, let's separate falling states)
// FALLING_RIGHT   = 3'b010 + fall_flag = 3'b110 (same)
//
// To distinguish digging and falling, bit2=1 means digging or falling.
// We'll use bit2=1 and a separate flag 'falling' to differentiate digging vs falling.
//
// To simplify, keep a separate 'falling' flag to distinguish falling vs digging when bit2=1.
//
// Final plan:
// State register:
//  - bit0: walk_left (active if 1)
//  - bit1: walk_right (active if 1)
//  - bit2: digging or falling flag (1 if digging or falling)
// Additional signal:
//  - falling (1 if falling)
// So state = {falling, walk_right, walk_left, digging}
// For simplicity, we keep a 4-bit state: {falling, digging, walk_right, walk_left}
// But since walking states can't be both left and right active simultaneously, only one of walk_right/walk_left is high.

// Let's encode:
// bit3 = falling (1 if falling, else 0)
// bit2 = digging (1 if digging, else 0)
// bit1 = walk_right (1 if walking or digging right, else 0)
// bit0 = walk_left (1 if walking or digging left, else 0)

// Valid states:
// Walking left:    4'b0001 (fall=0, dig=0, right=0, left=1)
// Walking right:   4'b0010
// Digging left:    4'b0101 (dig=1, left=1)
// Digging right:   4'b0110 (dig=1, right=1)
// Falling left:    4'b1001 (fall=1, left=1)
// Falling right:   4'b1010 (fall=1, right=1)

// During digging or falling:
// bump inputs ignored
// ground=0 triggers falling or remains falling
// ground=1 stops falling or digging appropriately

reg [3:0] state, next_state;

wire falling = state[3];
wire digging = state[2];
wire walk_right = state[1];
wire walk_left = state[0];

// Combine outputs straightforwardly:
assign walk_left = (!falling && !digging && state[0]);
assign walk_right = (!falling && !digging && state[1]);
assign digging = digging;
assign aaah = falling;

always @(*) begin
    // Default next state to current
    next_state = state;

    // Decode current direction
    // If walking or digging or falling, exactly one of walk_left or walk_right is set

    // Priority: fall > dig > bumps

    if (areset) begin
        // async reset handled in sequential always block
        next_state = 4'b0001; // walking left
    end else begin
        if (falling) begin
            // Falling state
            if (ground) begin
                // Landed: resume walking in current direction, falling cleared
                next_state = {1'b0, 1'b0, walk_right, walk_left};
            end else begin
                // Continue falling
                next_state = state;
            end
        end else if (digging) begin
            // Digging state
            if (!ground) begin
                // Ground lost, start falling same direction, digging cleared
                next_state = {1'b1, 1'b0, walk_right, walk_left};
            end else begin
                // Continue digging
                next_state = state;
            end
        end else begin
            // Walking state
            if (!ground) begin
                // Ground lost: start falling, direction unchanged
                next_state = {1'b1, 1'b0, walk_right, walk_left};
            end else if (dig) begin
                // Start digging if dig input and ground present
                next_state = {1'b0, 1'b1, walk_right, walk_left};
            end else begin
                // Handle bumps, bumps only affect direction when walking and on ground
                // Determine next direction depending on bumps:
                // If bump_left=1 and bump_right=1 => reverse direction
                // else if bump_left=1 => walk right
                // else if bump_right=1 => walk left
                // else no change

                if (bump_left && bump_right) begin
                    // reverse direction
                    if (walk_left) begin
                        next_state = {1'b0,1'b0,1'b1,1'b0}; // walk right
                    end else begin
                        next_state = {1'b0,1'b0,1'b0,1'b1}; // walk left
                    end
                end else if (bump_left) begin
                    // bump left => walk right
                    next_state = {1'b0,1'b0,1'b1,1'b0};
                end else if (bump_right) begin
                    // bump right => walk left
                    next_state = {1'b0,1'b0,1'b0,1'b1};
                end else begin
                    // no bump, stay
                    next_state = state;
                end
            end
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 4'b0001; // walking left
    end else begin
        state <= next_state;
    end
end

endmodule