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

localparam MODE_WALK = 2'b00;
localparam MODE_FALL = 2'b01;
localparam MODE_DIG  = 2'b10;

// State encoding: bits[2:1] = mode, bit[0] = direction (0=left,1=right)
reg [2:0] state;
wire [1:0] mode = state[2:1];
wire       dir  = state[0];

reg [2:0] next_state;

always @(*) begin
    // Default hold state
    next_state = state;

    case(mode)
        MODE_WALK: begin
            // Highest priority: falling when ground lost
            if (!ground) begin
                next_state = {MODE_FALL, dir};
            end
            // Then dig if dig=1 on ground and walking
            else if (dig) begin
                next_state = {MODE_DIG, dir};
            end
            // Then bump: if bump on either side, switch walking direction accordingly
            else if (bump_left || bump_right) begin
                if (bump_left && bump_right)
                    next_state = {MODE_WALK, ~dir};
                else if (bump_left)
                    next_state = {MODE_WALK, 1'b1}; // walk right
                else // bump_right
                    next_state = {MODE_WALK, 1'b0}; // walk left
            end
            // else remain walking same direction
        end

        MODE_FALL: begin
            // On ground regain, return to walking same direction
            if (ground)
                next_state = {MODE_WALK, dir};
            // else remain falling
        end

        MODE_DIG: begin
            // If ground lost while digging, start falling same direction
            if (!ground)
                next_state = {MODE_FALL, dir};
            // else remain digging
        end

        default: begin
            // Safe fallback: walk left
            next_state = {MODE_WALK, 1'b0};
        end
    endcase
end

// Asynchronous reset, synchronous update
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= {MODE_WALK, 1'b0}; // reset to walk left
    else
        state <= next_state;
end

// Outputs: Moore outputs derived purely from current state
assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule