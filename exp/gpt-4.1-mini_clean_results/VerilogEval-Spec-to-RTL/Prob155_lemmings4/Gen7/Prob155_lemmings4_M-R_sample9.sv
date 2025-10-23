module TopModule (
    input  clk,
    input  areset,       // asynchronous positive edge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    typedef enum logic [1:0] {
        WALK  = 2'd0,
        FALL  = 2'd1,
        DIG   = 2'd2,
        SPLAT = 2'd3
    } state_t;

    state_t state;
    logic dir;              // 0=left, 1=right
    logic [4:0] fall_count;

    // Next state variables as wires
    state_t next_state;
    logic next_dir;
    logic [4:0] next_fall_count;

    // Direction update when bumped in WALK state
    // According to spec, if both bumped or one side bumped, direction flips or sets
    wire bump_both = bump_left & bump_right;
    wire bump_only_left = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;

    // Fall count increment and saturation logic
    wire [4:0] fall_count_inc = (fall_count < 5'd31) ? (fall_count + 5'd1) : 5'd31;

    // Combinational logic for next state
    assign next_state = (state == SPLAT) ? SPLAT :
                        (state == WALK) ? (
                            (!ground)              ? FALL :
                            (dig && ground)        ? DIG :
                            WALK
                        ) :
                        (state == FALL) ? (
                            (ground) ? ((fall_count > 5'd20) ? SPLAT : WALK) : FALL
                        ) :
                        (state == DIG) ? (
                            (ground) ? DIG : FALL
                        ) :
                        WALK; // default fallback

    // Combinational logic for next_dir
    assign next_dir = (state == WALK) ? (
                        // Only update direction when walking and no fall/dig priority
                        bump_both     ? ~dir :
                        bump_only_left  ? 1'b1 :  // walk right
                        bump_only_right ? 1'b0 :  // walk left
                        dir
                     ) : dir; // direction holds during FALL, DIG, SPLAT

    // Combinational logic for next_fall_count
    assign next_fall_count = (state == FALL) ? (
                                (ground) ? 5'd0 : fall_count_inc
                             ) :
                             (next_state == FALL) ? 5'd1 : 5'd0;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0;      // initially walking left
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_count <= next_fall_count;
        end
    end

    // Moore outputs
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule