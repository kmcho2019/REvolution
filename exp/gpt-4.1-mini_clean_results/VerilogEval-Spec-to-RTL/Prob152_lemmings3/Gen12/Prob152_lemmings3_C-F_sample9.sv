module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode encoding in bits [2:1]
    localparam MODE_WALK = 2'b00,
               MODE_FALL = 2'b01,
               MODE_DIG  = 2'b10;

    // State register: [2:1] = mode, [0] = direction (0=left,1=right)
    reg [2:0] state;

    // Next state combinational logic
    reg [2:0] next_state;

    wire [1:0] mode = state[2:1];
    wire       dir  = state[0];

    always @(*) begin
        // Default: hold state
        next_state = state;

        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // falling overrides all
                    next_state = {MODE_FALL, dir};
                end else if (dig) begin
                    // dig if requested and on ground walking
                    next_state = {MODE_DIG, dir};
                end else if (bump_left || bump_right) begin
                    // bump handling: switch direction
                    if (bump_left && bump_right)
                        next_state = {MODE_WALK, ~dir};
                    else if (bump_left)
                        next_state = {MODE_WALK, 1'b1}; // walk right
                    else // bump_right only
                        next_state = {MODE_WALK, 1'b0}; // walk left
                end
                // else no change
            end

            MODE_FALL: begin
                if (ground) begin
                    // landed, resume walking same dir
                    next_state = {MODE_WALK, dir};
                end
                // else keep falling
            end

            MODE_DIG: begin
                if (!ground) begin
                    // ground lost while digging => fall
                    next_state = {MODE_FALL, dir};
                end
                // else keep digging
            end

            default: begin
                // undefined mode, reset to walk left
                next_state = {MODE_WALK, 1'b0};
            end
        endcase
    end

    // Sequential update with async reset in one always block (fusion of styles)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= {MODE_WALK, 1'b0}; // walk left on reset
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule