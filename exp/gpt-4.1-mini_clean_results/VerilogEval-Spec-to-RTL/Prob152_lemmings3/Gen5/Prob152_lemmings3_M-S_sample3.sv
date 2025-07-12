module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    // States
    localparam [1:0]
        WALK = 2'b00,
        FALL = 2'b01,
        DIG  = 2'b10;

    reg [1:0] state;
    reg       dir;          // 0 = left, 1 = right
    reg       prev_ground;

    wire bumped = bump_left | bump_right;
    wire ground_fell = (prev_ground == 1'b1) && (ground == 1'b0);
    wire ground_rose = (prev_ground == 1'b0) && (ground == 1'b1);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= WALK;
            dir         <= 1'b0;  // start walking left
            prev_ground <= 1'b1;  // assume starting on ground
        end else begin
            prev_ground <= ground;
            case (state)
                WALK: begin
                    if (ground_fell) begin
                        state <= FALL;
                        // direction unchanged
                    end else if (dig && ground) begin
                        state <= DIG;
                        // direction unchanged
                    end else if (bumped) begin
                        dir <= ~dir;  // switch direction on bump
                        // state unchanged
                    end
                    // else remain walking
                end

                FALL: begin
                    if (ground_rose) begin
                        state <= WALK;
                        // direction unchanged
                    end
                    // else remain falling
                end

                DIG: begin
                    if (!ground) begin
                        state <= FALL;
                        // direction unchanged
                    end
                    // else remain digging
                end

                default: begin
                    state <= WALK;
                    dir   <= 1'b0;
                end
            endcase
        end
    end

    // Moore outputs
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule