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

localparam MODE_WALK = 2'b00,
           MODE_FALL = 2'b01,
           MODE_DIG  = 2'b10;

reg [2:0] state; // [2:1] = mode, [0] = dir (0=left,1=right)

wire [1:0] mode = state[2:1];
wire dir = state[0];

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= {MODE_WALK, 1'b0}; // walk left
    else begin
        case (mode)
            MODE_WALK: begin
                if (!ground)
                    state <= {MODE_FALL, dir};
                else if (dig)
                    state <= {MODE_DIG, dir};
                else if (bump_left || bump_right) begin
                    // Switch direction on any bump
                    // bump left -> dir=1 (right), bump right-> dir=0 (left)
                    // bump both -> invert dir
                    if (bump_left && bump_right)
                        state <= {MODE_WALK, ~dir};
                    else if (bump_left)
                        state <= {MODE_WALK, 1'b1};
                    else
                        state <= {MODE_WALK, 1'b0};
                end else
                    state <= state; // no change
            end
            MODE_FALL: begin
                if (ground)
                    state <= {MODE_WALK, dir};
                else
                    state <= state;
            end
            MODE_DIG: begin
                if (!ground)
                    state <= {MODE_FALL, dir};
                else
                    state <= state;
            end
            default: state <= {MODE_WALK, 1'b0}; // safe default
        endcase
    end
end

assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule