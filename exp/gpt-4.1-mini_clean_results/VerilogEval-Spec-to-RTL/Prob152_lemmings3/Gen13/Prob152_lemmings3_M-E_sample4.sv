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

// State encoding (3 bits):
// bit 2: mode (0=walk/dig, 1=fall)
// bit 1: direction (0=left,1=right)
// bit 0: dig flag when mode=0 (0=walk,1=dig)

localparam [2:0]
    WLK_L = 3'b000,
    WLK_R = 3'b010,
    DIG_L = 3'b001,
    DIG_R = 3'b011,
    FAL_L = 3'b100,
    FAL_R = 3'b110;

reg [2:0] state, next_state;

wire mode = state[2];
wire dir  = state[1];
wire digf = state[0];

always @(*) begin
    next_state = state; // default hold

    if (mode == 1'b1) begin // falling states
        if (ground) begin
            // ground return: walk in same direction
            if (dir)
                next_state = WLK_R;
            else
                next_state = WLK_L;
        end
        // else keep falling
    end else if (digf == 1'b1) begin // digging
        if (!ground) begin
            // ground lost, start falling (direction preserved)
            if (dir)
                next_state = FAL_R;
            else
                next_state = FAL_L;
        end
        // else keep digging
    end else begin // walking
        if (!ground) begin
            // start falling
            if (dir)
                next_state = FAL_R;
            else
                next_state = FAL_L;
        end else if (dig) begin
            // start digging
            if (dir)
                next_state = DIG_R;
            else
                next_state = DIG_L;
        end else if (bump_left || bump_right) begin
            // bump causes direction switch or fix direction
            // if both bumps or one bump from opposite side, turn opposite
            if (bump_left && bump_right) begin
                if (dir)
                    next_state = WLK_L;
                else
                    next_state = WLK_R;
            end else if (bump_left) begin
                next_state = WLK_R;
            end else begin // bump_right only
                next_state = WLK_L;
            end
        end
        // else continue walking same direction
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WLK_L; // walk left on reset
    end else begin
        state <= next_state;
    end
end

assign walk_left  = (state == WLK_L);
assign walk_right = (state == WLK_R);
assign digging    = (state == DIG_L) || (state == DIG_R);
assign aaah       = (mode == 1'b1);

endmodule