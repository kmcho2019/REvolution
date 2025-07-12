module TopModule (
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

// State encoding
localparam WALK  = 2'b00;
localparam FALL  = 2'b01;
localparam DIG   = 2'b10;
localparam SPLAT = 2'b11;

reg [1:0] mode, next_mode;
reg dir, next_dir;         // 0=left,1=right
reg [4:0] fall_counter, next_fall_counter;

always @* begin
    // Defaults: stay the same
    next_mode = mode;
    next_dir = dir;
    next_fall_counter = fall_counter;

    if (mode == SPLAT) begin
        // Terminal state, remain here
        next_mode = SPLAT;
        next_dir = dir;
        next_fall_counter = 5'd0;
    end else if (mode == FALL) begin
        if (ground) begin
            // Landed: splat if fallen >20 cycles, else walk
            if (fall_counter > 5'd20) begin
                next_mode = SPLAT;
                next_fall_counter = 5'd0;
            end else begin
                next_mode = WALK;
                next_fall_counter = 5'd0;
            end
            next_dir = dir; // maintain direction
        end else begin
            // Continue falling: increment counter saturating at 31
            next_mode = FALL;
            next_dir = dir;
            next_fall_counter = (fall_counter < 5'd31) ? fall_counter + 5'd1 : fall_counter;
        end
    end else if (mode == DIG) begin
        if (!ground) begin
            // Ground lost while digging: start falling
            next_mode = FALL;
            next_fall_counter = 5'd1;
            next_dir = dir;
        end else begin
            // Continue digging, ignore bumps and dig input
            next_mode = DIG;
            next_dir = dir;
            next_fall_counter = 5'd0;
        end
    end else begin // WALK mode
        if (!ground) begin
            // Fall takes precedence over dig and bump
            next_mode = FALL;
            next_fall_counter = 5'd1;
            next_dir = dir;
        end else if (dig) begin
            // Start digging if on ground
            next_mode = DIG;
            next_fall_counter = 5'd0;
            next_dir = dir;
        end else begin
            // Handle bumps for direction
            next_mode = WALK;
            next_fall_counter = 5'd0;
            if (bump_left && bump_right) begin
                next_dir = ~dir;
            end else if (bump_left) begin
                next_dir = 1'b1; // walk right
            end else if (bump_right) begin
                next_dir = 1'b0; // walk left
            end else begin
                next_dir = dir;
            end
        end
    end
end

// Sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= WALK;
        dir <= 1'b0; // walk left initially
        fall_counter <= 5'd0;
    end else begin
        mode <= next_mode;
        dir <= next_dir;
        fall_counter <= next_fall_counter;
    end
end

// Moore outputs
assign walk_left  = (mode == WALK) && (dir == 1'b0);
assign walk_right = (mode == WALK) && (dir == 1'b1);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule