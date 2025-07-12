module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State + Direction combined encoding (3 bits):
    // bit[0] = direction: 0 = left, 1 = right
    // bits[2:1] = state:
    // 00 = WALK
    // 01 = FALL
    // 10 = DIG
    // 11 = SPLAT (direction bit ignored, but keep 0 for consistency)

    localparam [2:0]
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        FALL_LEFT  = 3'b010,
        FALL_RIGHT = 3'b011,
        DIG_LEFT   = 3'b100,
        DIG_RIGHT  = 3'b101,
        SPLAT      = 3'b110;

    reg [2:0] state_dir, next_state_dir;

    // Fall timer: 5 bits saturating counter
    reg [4:0] fall_count, next_fall_count;

    // Extract current state and direction
    wire [1:0] state_part = state_dir[2:1];
    wire dir_part = state_dir[0]; // 0=left,1=right

    // Helper function: invert direction bit
    function automatic [0:0] invert_dir(input [0:0] d);
        invert_dir = ~d;
    endfunction

    // State bits encoding
    localparam [1:0]
        ST_WALK = 2'b00,
        ST_FALL = 2'b01,
        ST_DIG  = 2'b10,
        ST_SPLAT= 2'b11;

    // Asynchronous posedge reset logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_dir <= WALK_LEFT;  // initial: walk left
            fall_count <= 5'd0;
        end else begin
            state_dir <= next_state_dir;
            fall_count <= next_fall_count;
        end
    end

    // Next state and fall_count logic
    always @(*) begin
        // Default: hold current values
        next_state_dir = state_dir;
        next_fall_count = fall_count;

        case (state_part)
            ST_WALK: begin
                if (ground == 1'b0) begin
                    // start falling, fall_count = 1
                    next_state_dir = {ST_FALL, dir_part};
                    next_fall_count = 5'd1;
                end else if (dig == 1'b1) begin
                    // start digging
                    next_state_dir = {ST_DIG, dir_part};
                    next_fall_count = 5'd0;
                end else begin
                    // Handle bumps: fall>dig>bump; we're here bump
                    // bump_left-> walk right (dir=1)
                    // bump_right-> walk left (dir=0)
                    // both bump -> reverse dir
                    if (bump_left && bump_right) begin
                        next_state_dir = {ST_WALK, invert_dir(dir_part)};
                    end else if (bump_left) begin
                        next_state_dir = {ST_WALK, 1'b1}; // walk right
                    end else if (bump_right) begin
                        next_state_dir = {ST_WALK, 1'b0}; // walk left
                    end else begin
                        // no bump, remain same
                        next_state_dir = state_dir;
                    end
                    next_fall_count = 5'd0;
                end
            end

            ST_FALL: begin
                if (ground == 1'b0) begin
                    // continue falling, increment saturating at 31
                    next_state_dir = state_dir;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 5'd1 : fall_count;
                end else begin
                    // landed: splat if fall_count > 20 else walk same dir
                    if (fall_count > 5'd20) begin
                        next_state_dir = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state_dir = {ST_WALK, dir_part};
                        next_fall_count = 5'd0;
                    end
                end
            end

            ST_DIG: begin
                if (ground == 1'b0) begin
                    // start falling from dig
                    next_state_dir = {ST_FALL, dir_part};
                    next_fall_count = 5'd1;
                end else begin
                    // continue digging
                    next_state_dir = state_dir;
                    next_fall_count = 5'd0;
                end
            end

            ST_SPLAT: begin
                // forever splatted
                next_state_dir = SPLAT;
                next_fall_count = 5'd0;
            end

            default: begin
                // safe reset fallback
                next_state_dir = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Outputs: Moore style derived from state_dir
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (state_part)
            ST_WALK: begin
                if (dir_part == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            ST_FALL: begin
                aaah = 1'b1;
            end
            ST_DIG: begin
                digging = 1'b1;
            end
            ST_SPLAT: begin
                // all outputs zero
            end
            default: begin
                // outputs zero
            end
        endcase
    end

endmodule