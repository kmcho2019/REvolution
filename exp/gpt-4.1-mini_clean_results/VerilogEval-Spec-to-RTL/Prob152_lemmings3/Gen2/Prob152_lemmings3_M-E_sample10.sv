module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah,
    output reg  digging
);

    // Directions
    localparam LEFT  = 1'b0;
    localparam RIGHT = 1'b1;

    // Modes
    localparam MODE_WALK = 2'd0;
    localparam MODE_FALL = 2'd1;
    localparam MODE_DIG  = 2'd2;

    reg dir_reg, dir_next;    // current direction: 0=left,1=right
    reg [1:0] mode_reg, mode_next; // current mode

    // Combinational next state logic
    always @(*) begin
        // Default to current values
        dir_next = dir_reg;
        mode_next = mode_reg;

        case (mode_reg)
            MODE_WALK: begin
                // Check for fall first
                if (!ground) begin
                    mode_next = MODE_FALL;
                    // direction unchanged
                end
                // then dig
                else if (dig) begin
                    mode_next = MODE_DIG;
                    // direction unchanged
                end
                else begin
                    // Walking on ground: bump causes direction change
                    if (bump_left || bump_right) begin
                        // Switch direction
                        dir_next = (dir_reg == LEFT) ? RIGHT : LEFT;
                    end
                    mode_next = MODE_WALK;
                end
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed, resume walking in same direction
                    mode_next = MODE_WALK;
                    // direction unchanged
                end else begin
                    mode_next = MODE_FALL;
                    // direction unchanged
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // started fall after dig side ends
                    mode_next = MODE_FALL;
                    // direction unchanged
                end else begin
                    // Keep digging as long as on ground
                    mode_next = MODE_DIG;
                    // direction unchanged
                end
            end

            default: begin
                // Should never happen, reset to walk left
                mode_next = MODE_WALK;
                dir_next = LEFT;
            end
        endcase
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir_reg <= LEFT;
            mode_reg <= MODE_WALK;
        end else begin
            dir_reg <= dir_next;
            mode_reg <= mode_next;
        end
    end

    // Moore outputs based on mode and direction
    always @(*) begin
        // Defaults
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (mode_reg)
            MODE_WALK: begin
                if (dir_reg == LEFT)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end

            MODE_FALL: begin
                aaah = 1'b1;
            end

            MODE_DIG: begin
                digging = 1'b1;
                if (dir_reg == LEFT)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end

            default: begin
                // safe default no outputs asserted
            end
        endcase
    end

endmodule