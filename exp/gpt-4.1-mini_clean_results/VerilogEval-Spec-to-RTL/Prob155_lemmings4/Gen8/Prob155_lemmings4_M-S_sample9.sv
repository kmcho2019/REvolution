module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode encoding (2 bits)
    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    // Combined register: [2:1] = mode, [0] = direction (0=left,1=right)
    reg [2:0] state, next_state;
    // Separate fall timer
    reg [4:0] fall_timer, next_fall_timer;

    wire [1:0] mode = state[2:1];
    wire       direction = state[0];

    // Sequential logic with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= {MODE_WALK, 1'b0}; // walk left
            fall_timer  <= 5'd0;
        end else begin
            state       <= next_state;
            fall_timer  <= next_fall_timer;
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state       = state;
        next_fall_timer  = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever
                next_state      = state;
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    if (fall_timer > 5'd20) begin
                        // splat
                        next_state      = {MODE_SPLAT, direction};
                        next_fall_timer = 5'd0;
                    end else begin
                        // land and resume walking same direction
                        next_state      = {MODE_WALK, direction};
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    // continue falling, increment fall_timer saturating at 31
                    next_state      = state;
                    next_fall_timer = (fall_timer < 5'd31) ? (fall_timer + 1) : fall_timer;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // start falling with timer=1
                    next_state      = {MODE_FALL, direction};
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // start digging
                    next_state      = {MODE_DIG, direction};
                    next_fall_timer = 5'd0;
                end else if (bump_left || bump_right) begin
                    // change direction on bump
                    // both bumps toggle direction
                    // bump left -> walk right, bump right -> walk left
                    reg new_dir;
                    if (bump_left && bump_right)
                        new_dir = ~direction;
                    else if (bump_left)
                        new_dir = 1'b1; // right
                    else
                        new_dir = 1'b0; // left
                    next_state      = {MODE_WALK, new_dir};
                    next_fall_timer = 5'd0;
                end else begin
                    // keep walking same direction
                    next_state      = state;
                    next_fall_timer = 5'd0;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // ground disappeared, start falling with timer=1
                    next_state      = {MODE_FALL, direction};
                    next_fall_timer = 5'd1;
                end else begin
                    // keep digging
                    next_state      = state;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // fallback to walking left
                next_state      = {MODE_WALK, 1'b0};
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule