module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding
    localparam LEFT_WALK  = 2'b00;
    localparam RIGHT_WALK = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state;
    reg       dir;  // 0=left, 1=right; only meaningful when walking or saved during falling

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT_WALK;
            dir   <= 1'b0; // left
        end else begin
            case (state)
                LEFT_WALK: begin
                    if (!ground) begin
                        state <= FALLING;
                        // dir stays at 0 (left)
                    end else if (bump_left || bump_right) begin
                        // On bump, change direction according to bump logic
                        if (bump_left && bump_right)
                            dir <= ~dir; // flip direction if both bumps
                        else if (bump_left)
                            dir <= 1'b1; // walk right
                        else if (bump_right)
                            dir <= 1'b0; // walk left

                        // Update state according to dir
                        if (dir == 1'b0) begin
                            state <= LEFT_WALK;
                        end else begin
                            state <= RIGHT_WALK;
                        end
                    end else begin
                        state <= LEFT_WALK;
                        dir <= 1'b0; // ensure dir matches walking left state
                    end
                end

                RIGHT_WALK: begin
                    if (!ground) begin
                        state <= FALLING;
                        // dir stays at 1 (right)
                    end else if (bump_left || bump_right) begin
                        if (bump_left && bump_right)
                            dir <= ~dir;
                        else if (bump_left)
                            dir <= 1'b1;
                        else if (bump_right)
                            dir <= 1'b0;

                        if (dir == 1'b0)
                            state <= LEFT_WALK;
                        else
                            state <= RIGHT_WALK;
                    end else begin
                        state <= RIGHT_WALK;
                        dir <= 1'b1;
                    end
                end

                FALLING: begin
                    if (ground) begin
                        // Return to walking in saved direction
                        if (dir == 1'b0)
                            state <= LEFT_WALK;
                        else
                            state <= RIGHT_WALK;
                    end else begin
                        state <= FALLING;
                        // dir unchanged while falling, bumps ignored
                    end
                end

                default: begin
                    state <= LEFT_WALK;
                    dir <= 1'b0;
                end
            endcase
        end
    end

    assign walk_left  = (state != FALLING) && (dir == 1'b0);
    assign walk_right = (state != FALLING) && (dir == 1'b1);
    assign aaah       = (state == FALLING);

endmodule