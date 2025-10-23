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

// Mode encoding
localparam MODE_WALK = 2'd0;
localparam MODE_FALL = 2'd1;
localparam MODE_DIG  = 2'd2;

reg dir;    // 0=left, 1=right
reg [1:0] mode;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Async reset: walk left
        dir <= 1'b0;
        mode <= MODE_WALK;
    end else begin
        // Next mode and dir computed combinationally below
        case (mode)
            MODE_WALK: begin
                // Priority: falling > digging > bump direction change
                if (!ground) begin
                    // Start falling, same dir
                    mode <= MODE_FALL;
                end else if (dig) begin
                    // Start digging if dig=1 and ground=1
                    mode <= MODE_DIG;
                end else begin
                    mode <= MODE_WALK;
                end

                if (!ground || dig) begin
                    // Direction not changed here
                    dir <= dir;
                end else begin
                    // Bumps only affect direction if walking on ground and not falling/digging
                    if (bump_left && bump_right) begin
                        dir <= ~dir;
                    end else if (bump_left) begin
                        dir <= 1'b1; // walk right
                    end else if (bump_right) begin
                        dir <= 1'b0; // walk left
                    end else begin
                        dir <= dir;
                    end
                end
            end
            MODE_FALL: begin
                // Falling: if ground appears, walk same direction
                if (ground) begin
                    mode <= MODE_WALK;
                end else begin
                    mode <= MODE_FALL;
                end
                // Direction unchanged during fall
                dir <= dir;
            end
            MODE_DIG: begin
                // Digging: if ground lost, start falling same direction
                if (!ground) begin
                    mode <= MODE_FALL;
                end else begin
                    mode <= MODE_DIG;
                end
                // Direction unchanged during dig
                dir <= dir;
            end
            default: begin
                // Failsafe: return to walk left
                mode <= MODE_WALK;
                dir <= 1'b0;
            end
        endcase
    end
end

// Output logic - Moore machine outputs depend only on current state
assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule