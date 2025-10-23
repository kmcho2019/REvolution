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

    // State encoding
    localparam WALK = 2'b00;
    localparam DIG  = 2'b01;
    localparam FALL = 2'b10;

    reg [1:0] state, next_state;
    reg dir, next_dir; // 0=left, 1=right

    // Next-state logic
    always @(*) begin
        // defaults
        next_state = state;
        next_dir   = dir;

        case(state)
            FALL: begin
                // If ground appears, stop falling, resume walking same dir
                if (ground)
                    next_state = WALK;
                // else remain falling
                // bumps ignored when falling
            end

            DIG: begin
                if (!ground) begin
                    // ground lost, start falling
                    next_state = FALL;
                end
                // else continue digging
                // bumps ignored when digging
            end

            WALK: begin
                if (!ground) begin
                    // start falling if no ground
                    next_state = FALL;
                end else if (dig) begin
                    // start digging if dig command and on ground
                    next_state = DIG;
                end else if (bump_left || bump_right) begin
                    // change direction on bump(s)
                    // bumps only affect direction when walking on ground
                    if (bump_left && bump_right) begin
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        next_dir = 1'b1; // walk right
                    end else begin
                        next_dir = 1'b0; // walk left
                    end
                end
                // else keep walking same dir
            end

            default: begin
                next_state = WALK;
                next_dir = 1'b0;
            end
        endcase
    end

    // State and direction update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0; // walk left
        end else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // Outputs assigned as Moore outputs
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule