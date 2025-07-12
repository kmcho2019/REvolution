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

    // Mode encoding
    localparam MODE_WALK = 2'b00,
               MODE_FALL = 2'b01,
               MODE_DIG  = 2'b10;

    // Separate registers for mode and direction
    reg [1:0] mode, next_mode;
    reg       dir,  next_dir;  // 0 = left, 1 = right

    // Next state combinational logic using assign statements

    // Falling has highest priority
    wire falling_start = (mode == MODE_WALK) && (ground == 1'b0);
    wire walking_on_ground = (mode == MODE_WALK) && (ground == 1'b1);
    wire digging_start = walking_on_ground && dig;

    // Direction switching conditions
    // Only active when walking on ground (and not falling/digging)
    wire bump_both = bump_left && bump_right;
    wire bump_any = bump_left || bump_right;

    // Next mode logic
    assign next_mode = (mode == MODE_WALK) ? 
                           (falling_start ? MODE_FALL :
                            digging_start ? MODE_DIG :
                            MODE_WALK)
                       : (mode == MODE_FALL) ?
                           (ground ? MODE_WALK : MODE_FALL)
                       : (mode == MODE_DIG) ?
                           (ground ? MODE_DIG : MODE_FALL)
                       : MODE_WALK; // default fallback

    // Next direction logic
    // Direction changes only in walking mode when bumped
    assign next_dir = (mode == MODE_WALK && ground == 1'b1) ? 
                        (bump_both ? ~dir :
                         bump_left ? 1'b1 :   // bump left => walk right
                         bump_right ? 1'b0 :  // bump right => walk left
                         dir)
                     : dir; // no change in other modes or no ground

    // Sequential always block with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            dir <= 1'b0; // walk left on reset
        end else begin
            mode <= next_mode;
            dir <= next_dir;
        end
    end

    // Moore outputs decoded from mode and direction
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule