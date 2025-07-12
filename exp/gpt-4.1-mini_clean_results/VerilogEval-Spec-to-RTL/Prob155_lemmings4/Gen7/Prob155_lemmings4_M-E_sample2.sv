module TopModule(
    input  clk,
    input  areset,      // async reset, active high
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// One-hot encoding of states for faster decoding
localparam WALK_BIT = 3'd0;
localparam DIG_BIT  = 3'd1;
localparam FALL_BIT = 3'd2;
// SPLAT state is encoded differently (all zeros in one-hot vector)
localparam SPLAT_STATE = 3'b000;

// State registers (one-hot)
reg [2:0] state, next_state;
// Direction: 0 = left, 1 = right
reg direction, next_direction;
// Fall timer: count falling cycles, saturate at 63 (6 bits)
reg [5:0] fall_timer, next_fall_timer;

// Async reset and sequential update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state       <= 3'b001;      // WALK state
        direction   <= 1'b0;        // Walk left
        fall_timer  <= 6'd0;
    end else begin
        state       <= next_state;
        direction   <= next_direction;
        fall_timer  <= next_fall_timer;
    end
end

// Determine if current state
wire walking = (state == 3'b001);
wire digging = (state == 3'b010);
wire falling = (state == 3'b100);
wire splatted = (state == SPLAT_STATE);

// Compute priority signals
wire fall_condition = (ground == 1'b0);
wire dig_condition  = (ground == 1'b1) && dig && walking; // dig only when walking on ground
wire bumped = bump_left | bump_right;

// Next state combinational logic
always @(*) begin
    // Default next values hold current
    next_state       = state;
    next_direction   = direction;
    next_fall_timer  = fall_timer;

    if (splatted) begin
        // Remain splatted forever until reset
        next_state      = SPLAT_STATE;
        next_direction  = direction;
        next_fall_timer = 6'd0;
    end else if (falling) begin
        // Falling state
        if (ground) begin
            // Landed after fall
            if (fall_timer > 6'd20) begin
                // Splatter condition met
                next_state      = SPLAT_STATE;
                next_fall_timer = 6'd0;
            end else begin
                // Return to walking with previous direction
                next_state      = 3'b001; // WALK
                next_fall_timer = 6'd0;
            end
            // Direction unchanged on landing
            next_direction = direction;
        end else begin
            // Continue falling
            next_state = 3'b100; // FALL
            // Increment fall timer, saturate at max 63
            if (fall_timer < 6'd63)
                next_fall_timer = fall_timer + 6'd1;
            else
                next_fall_timer = fall_timer;
            // Direction unchanged while falling
            next_direction = direction;
        end
    end else if (walking) begin
        // Walking state: check fall first (highest priority)
        if (fall_condition) begin
            next_state      = 3'b100; // FALL
            next_fall_timer = 6'd1;   // start counting from 1
            next_direction  = direction;
        end else if (dig_condition) begin
            // Start digging when on ground and dig asserted
            next_state      = 3'b010; // DIG
            next_fall_timer = 6'd0;
            next_direction  = direction;
        end else begin
            // Handle bump direction switches only if no fall or dig
            next_state      = 3'b001; // remain walking
            next_fall_timer = 6'd0;
            if (bump_left && bump_right) begin
                // both bumps -> toggle direction
                next_direction = ~direction;
            end else if (bump_left) begin
                // bumped on left -> walk right
                next_direction = 1'b1;
            end else if (bump_right) begin
                // bumped on right -> walk left
                next_direction = 1'b0;
            end else begin
                // no bump, direction stays
                next_direction = direction;
            end
        end
    end else if (digging) begin
        // Digging state
        if (fall_condition) begin
            // ground lost while digging: fall overrides dig
            next_state      = 3'b100; // FALL
            next_fall_timer = 6'd1;
            next_direction  = direction;
        end else begin
            // Continue digging on ground, ignore bumps and dig signal
            next_state      = 3'b010; // DIG
            next_fall_timer = 6'd0;
            next_direction  = direction;
        end
    end else begin
        // Undefined or initial state: reset to walking left
        next_state      = 3'b001; // WALK
        next_direction  = 1'b0;
        next_fall_timer = 6'd0;
    end
end

// Moore outputs based on registered state and direction
assign walk_left  = walking && (direction == 1'b0);
assign walk_right = walking && (direction == 1'b1);
assign aaah       = falling;
assign digging    = digging && (state == 3'b010); // explicit

endmodule