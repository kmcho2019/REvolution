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

// State encoding:
// [2] = direction (0=left,1=right)
// [1:0] = mode: 00=walk,01=fall,10=dig
localparam MODE_WALK = 2'b00;
localparam MODE_FALL = 2'b01;
localparam MODE_DIG  = 2'b10;

reg [2:0] state; // {dir, mode[1:0]}

wire dir = state[2];
wire [1:0] mode = state[1:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= {1'b0, MODE_WALK}; // walk left
    end else begin
        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // fall, keep direction
                    state <= {dir, MODE_FALL};
                end else if (dig) begin
                    // dig, keep direction
                    state <= {dir, MODE_DIG};
                end else if (bump_left || bump_right) begin
                    // update direction based on bumps:
                    // if both bumps or just left bump, go right (dir=1)
                    // else if right bump only, go left (dir=0)
                    // simplified logic:
                    // new_dir = bump_left | (~bump_right & dir)
                    // but we must ensure if bump_left and bump_right both 1 -> flip
                    // Actually, problem states:
                    // if bump_left & bump_right, still switch direction (flip dir)
                    // So logic:
                    // if bump_left and bump_right: flip dir
                    // else if bump_left: dir=1
                    // else if bump_right: dir=0
                    if (bump_left && bump_right)
                        state <= {~dir, MODE_WALK};
                    else if (bump_left)
                        state <= {1'b1, MODE_WALK};
                    else // bump_right only
                        state <= {1'b0, MODE_WALK};
                end else begin
                    // no change
                    state <= state;
                end
            end

            MODE_FALL: begin
                if (ground) begin
                    // resume walking, same direction
                    state <= {dir, MODE_WALK};
                end else begin
                    state <= state;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // hit edge, start falling, keep direction
                    state <= {dir, MODE_FALL};
                end else begin
                    state <= state;
                end
            end

            default: begin
                // Should not happen, reset state
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