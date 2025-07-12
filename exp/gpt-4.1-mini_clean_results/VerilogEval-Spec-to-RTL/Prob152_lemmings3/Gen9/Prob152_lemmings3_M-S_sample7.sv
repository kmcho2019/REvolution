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

// State mode encoding (2 bits)
localparam MODE_WALK = 2'b00;
localparam MODE_FALL = 2'b01;
localparam MODE_DIG  = 2'b10;

// State bits:
// bit 2: direction (0=left,1=right)
// bits 1-0: mode

reg [2:0] state, next_state;
reg prev_ground;

wire dir = state[2];
wire [1:0] mode = state[1:0];

// For stable ground: ground high this cycle and previous cycle
wire stable_ground = ground & prev_ground;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to walking left and assume starting on ground
        state <= {1'b0, MODE_WALK};
        prev_ground <= 1'b1;
    end else begin
        state <= next_state;
        prev_ground <= ground;
    end
end

always @(*) begin
    next_state = state; // default hold
    
    case (mode)
        MODE_WALK: begin
            // Priority: fall > dig > bump
            if (!ground) begin
                // Start falling same direction
                next_state = {dir, MODE_FALL};
            end else if (dig && stable_ground) begin
                // Start digging
                next_state = {dir, MODE_DIG};
            end else if (stable_ground && (bump_left || bump_right)) begin
                // Bump logic:
                if (bump_left && bump_right) begin
                    // Both bumps flip direction
                    next_state = {~dir, MODE_WALK};
                end else if (bump_left) begin
                    // bump left -> walk right
                    next_state = {1'b1, MODE_WALK};
                end else begin
                    // bump right -> walk left
                    next_state = {1'b0, MODE_WALK};
                end
            end
        end
        
        MODE_FALL: begin
            // Remain falling until ground reappears
            if (ground) begin
                next_state = {dir, MODE_WALK};
            end
        end
        
        MODE_DIG: begin
            // Keep digging while ground, else fall
            if (!ground) begin
                next_state = {dir, MODE_FALL};
            end
        end
        
        default: begin
            // Unknown mode, reset to walk left
            next_state = {1'b0, MODE_WALK};
        end
    endcase
end

// Outputs depend only on current state (Moore)
// Walking outputs
assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
// Falling output
assign aaah       = (mode == MODE_FALL);
// Digging output
assign digging    = (mode == MODE_DIG);

endmodule