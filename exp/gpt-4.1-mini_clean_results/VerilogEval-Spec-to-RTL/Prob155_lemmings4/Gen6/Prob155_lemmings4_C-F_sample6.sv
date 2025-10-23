module TopModule (
    input  clk,
    input  areset,       // async posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // Combined state+direction encoding (3 bits):
    // bit0 = direction: 0=left, 1=right
    // bits2:1 = mode:
    //   00 = WALK
    //   01 = FALL
    //   10 = DIG
    //   11 = SPLAT (direction ignored)
    localparam [2:0]
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        FALL_LEFT  = 3'b010,
        FALL_RIGHT = 3'b011,
        DIG_LEFT   = 3'b100,
        DIG_RIGHT  = 3'b101,
        SPLAT      = 3'b110;

    // Modes encoding (bits2:1)
    localparam [1:0]
        MODE_WALK = 2'b00,
        MODE_FALL = 2'b01,
        MODE_DIG  = 2'b10,
        MODE_SPLAT= 2'b11;

    reg [2:0] state_dir, next_state_dir;
    reg [4:0] fall_count, next_fall_count; // saturating fall timer (max 31)

    // Extract mode and direction from state_dir
    wire [1:0] mode = state_dir[2:1];
    wire dir = state_dir[0]; // 0=left,1=right

    // Function to invert direction bit
    function automatic invert_dir(input bit d);
        invert_dir = ~d;
    endfunction

    // Sequential logic with async posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_dir <= WALK_LEFT;  // reset walking left
            fall_count <= 5'd0;
        end else begin
            state_dir <= next_state_dir;
            fall_count <= next_fall_count;
        end
    end

    // Next-state and fall_count combinational logic
    always @(*) begin
        // Defaults keep current values
        next_state_dir = state_dir;
        next_fall_count = fall_count;

        case (mode)
            MODE_WALK: begin
                if (ground == 1'b0) begin
                    // Fall start on losing ground
                    next_state_dir = {MODE_FALL, dir};
                    next_fall_count = 5'd1;
                end else if (dig == 1'b1) begin
                    // Start digging on ground
                    next_state_dir = {MODE_DIG, dir};
                    next_fall_count = 5'd0;
                end else begin
                    // Handle bumps with priority:
                    // if bump_left & bump_right: toggle dir
                    // else if bump_left: walk right (dir=1)
                    // else if bump_right: walk left (dir=0)
                    if (bump_left && bump_right) begin
                        next_state_dir = {MODE_WALK, invert_dir(dir)};
                    end else if (bump_left) begin
                        next_state_dir = {MODE_WALK, 1'b1}; // walk right
                    end else if (bump_right) begin
                        next_state_dir = {MODE_WALK, 1'b0}; // walk left
                    end else begin
                        next_state_dir = state_dir;
                    end
                    next_fall_count = 5'd0;
                end
            end

            MODE_FALL: begin
                if (ground == 1'b0) begin
                    // Continue falling, saturate counter at 31
                    next_state_dir = state_dir;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 5'd1 : fall_count;
                end else begin
                    // Landed: splatter if fallen >20 cycles, else walk
                    if (fall_count > 5'd20) begin
                        next_state_dir = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state_dir = {MODE_WALK, dir};
                        next_fall_count = 5'd0;
                    end
                end
            end

            MODE_DIG: begin
                if (ground == 1'b0) begin
                    // Digging lost ground: fall start
                    next_state_dir = {MODE_FALL, dir};
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging on ground, ignore bumps and dig
                    next_state_dir = state_dir;
                    next_fall_count = 5'd0;
                end
            end

            MODE_SPLAT: begin
                // Stay splatted forever, all outputs zero
                next_state_dir = SPLAT;
                next_fall_count = 5'd0;
            end

            default: begin
                // Safety fallback to walking left
                next_state_dir = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Outputs (Moore)
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case (mode)
            MODE_WALK: begin
                if (dir == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            MODE_FALL: aaah = 1'b1;
            MODE_DIG:  digging = 1'b1;
            MODE_SPLAT: begin
                // all outputs zero
            end
        endcase
    end

endmodule