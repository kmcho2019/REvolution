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

// State encoding: [2] = direction (0=left,1=right), [1:0] = mode
// 3-bit state: {dir, mode}
reg [2:0] state;

wire dir = state[2];
wire [1:0] mode = state[1:0];

// Combine bump signals into one for clarity
wire bump_any = bump_left | bump_right;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= {1'b0, MODE_WALK}; // direction=0 (left), mode=walk
    end else begin
        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Start falling, keep same direction
                    state <= {dir, MODE_FALL};
                end else if (dig) begin
                    // Start digging, keep same direction
                    state <= {dir, MODE_DIG};
                end else if (bump_any) begin
                    // Switch direction if bumped left or right or both
                    // Direction after bump: if bump_left =1 => walk right (1)
                    // else if bump_right=1 => walk left (0)
                    // if both bumps 1, invert direction
                    // Simplify to: new_dir = bump_left | (~bump_right & dir)
                    // but per spec bump_left => walk right (dir=1)
                    // bump_right => walk left (dir=0)
                    // both bumps => invert dir
                    // Equivalently:
                    // if (bump_left && bump_right) new_dir = ~dir
                    // else if bump_left new_dir=1
                    // else new_dir=0

                    reg new_dir;
                    if (bump_left && bump_right)
                        new_dir = ~dir;
                    else if (bump_left)
                        new_dir = 1'b1;
                    else
                        new_dir = 1'b0;
                    state <= {new_dir, MODE_WALK};
                end
                // else stay walking, no change
            end

            MODE_FALL: begin
                if (ground) begin
                    // Land and resume walking in same direction
                    state <= {dir, MODE_WALK};
                end
                // else continue falling
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Reach edge, start falling in same direction
                    state <= {dir, MODE_FALL};
                end
                // else keep digging
            end

            default: begin
                // Should not occur, reset to walk left
                state <= {1'b0, MODE_WALK};
            end
        endcase
    end
end

assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule