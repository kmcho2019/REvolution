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

// Mode encoding (2 bits)
localparam MODE_WALK = 2'b00;
localparam MODE_FALL = 2'b01;
localparam MODE_DIG  = 2'b10;

// Direction encoding
localparam DIR_LEFT  = 1'b0;
localparam DIR_RIGHT = 1'b1;

// State vector: {direction, mode}
// 3 bits total: bit 2 = direction, bits 1:0 = mode
reg [2:0] state, next_state;

// Register to hold previous ground state for stable ground detection
reg prev_ground;

wire dir  = state[2];
wire [1:0] mode = state[1:0];

// Stable ground indicates ground was high previous cycle and is high now
wire stable_ground = ground & prev_ground;

// Sequential logic: update state and prev_ground simultaneously with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= {DIR_LEFT, MODE_WALK}; // Reset to walk left
        prev_ground <= 1'b1;            // Assume starting on ground
    end else begin
        state <= next_state;
        prev_ground <= ground;
    end
end

// Combinational next state logic with priority: fall > dig > bump direction switch
always @(*) begin
    next_state = state; // default hold
    
    case (mode)
        MODE_WALK: begin
            // Priority 1: fall if ground lost (falling overrides all)
            if (!ground) begin
                next_state = {dir, MODE_FALL};
            end 
            // Priority 2: start digging only if walking, dig asserted, and stable ground
            else if (dig && stable_ground) begin
                next_state = {dir, MODE_DIG};
            end 
            // Priority 3: bump direction switch if walking and stable ground
            else if (stable_ground && (bump_left || bump_right)) begin
                // If both bumps, flip direction
                if (bump_left && bump_right) begin
                    next_state = {~dir, MODE_WALK};
                end else if (bump_left) begin
                    next_state = {DIR_RIGHT, MODE_WALK};
                end else begin // bump_right
                    next_state = {DIR_LEFT, MODE_WALK};
                end
            end
            // Else stay walking same direction
        end

        MODE_FALL: begin
            // Falling: return to walking same direction once ground is regained
            if (ground)
                next_state = {dir, MODE_WALK};
            else
                next_state = state;
        end

        MODE_DIG: begin
            // Digging: continue while ground present, else start falling
            if (!ground)
                next_state = {dir, MODE_FALL};
            else
                next_state = state;
        end

        default: begin
            // Safety fallback: reset to walk left
            next_state = {DIR_LEFT, MODE_WALK};
        end
    endcase
end

// Outputs are Moore: depend only on current state
assign walk_left  = (mode == MODE_WALK) && (dir == DIR_LEFT);
assign walk_right = (mode == MODE_WALK) && (dir == DIR_RIGHT);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule