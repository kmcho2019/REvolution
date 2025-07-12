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

// State encoding (3 bits):
// bit 2: mode (0=walk/dig, 1=fall)
// bit 1: direction (0=left,1=right)
// bit 0: dig flag when mode=0 (0=walk,1=dig)
localparam [2:0]
    WLK_L = 3'b000,
    DIG_L = 3'b001,
    WLK_R = 3'b010,
    DIG_R = 3'b011,
    FAL_L = 3'b100,
    FAL_R = 3'b110;

reg [2:0] state, next_state;

wire mode = state[2];
wire dir  = state[1];
wire digf = state[0];

// Combinational next state logic with priority: fall > dig > bump
always @* begin
    next_state = state; // default hold

    if (mode) begin // currently falling
        if (ground) begin
            // ground reappeared, walk in same direction
            next_state = dir ? WLK_R : WLK_L;
        end
        // else remain falling
    end else if (digf) begin // currently digging
        if (!ground) begin
            // ground lost, start falling with same direction
            next_state = dir ? FAL_R : FAL_L;
        end
        // else keep digging
    end else begin // currently walking
        if (!ground) begin
            // ground lost, start falling same direction
            next_state = dir ? FAL_R : FAL_L;
        end else if (dig) begin
            // start digging same direction
            next_state = dir ? DIG_R : DIG_L;
        end else if (bump_left || bump_right) begin
            // bump causes direction switch
            // if both bumps or one bump on opposite side, flip direction
            if (bump_left && bump_right) begin
                next_state = dir ? WLK_L : WLK_R;
            end else if (bump_left) begin
                next_state = WLK_R;
            end else begin // bump_right only
                next_state = WLK_L;
            end
        end
        // else remain walking same direction
    end
end

// Sequential state update with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WLK_L; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Output signals from state bits
assign walk_left  = (state == WLK_L);
assign walk_right = (state == WLK_R);
assign digging    = (state == DIG_L) || (state == DIG_R);
assign aaah       = mode;

endmodule