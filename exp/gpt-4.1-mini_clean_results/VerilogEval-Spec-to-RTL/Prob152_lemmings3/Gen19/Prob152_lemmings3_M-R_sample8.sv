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
    localparam WALK  = 2'd0;
    localparam FALL  = 2'd1;
    localparam DIG   = 2'd2;

    reg [1:0] state, next_state;
    reg dir, next_dir; // 0=left, 1=right

    // Next-state and next-dir combinational logic
    always @(*) begin
        // Default assignments: hold current values
        next_state = state;
        next_dir = dir;

        case (state)
            FALL: begin
                if (ground)
                    next_state = WALK; // resume walking on ground
            end
            DIG: begin
                if (!ground)
                    next_state = FALL; // fall if no ground beneath while digging
            end
            WALK: begin
                if (!ground) begin
                    next_state = FALL; // fall if no ground while walking
                end else if (dig) begin
                    next_state = DIG; // start digging if commanded and on ground
                end else begin
                    // handle bumping only if no fall or dig triggered
                    if (bump_left && bump_right)
                        next_dir = ~dir; // reverse direction
                    else if (bump_left)
                        next_dir = 1'b1; // walk right
                    else if (bump_right)
                        next_dir = 1'b0; // walk left
                end
            end
        endcase
    end

    // Sequential logic: registers updated on posedge clk or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0; // walk left initially
        end else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // Outputs are combinational from state and dir
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule