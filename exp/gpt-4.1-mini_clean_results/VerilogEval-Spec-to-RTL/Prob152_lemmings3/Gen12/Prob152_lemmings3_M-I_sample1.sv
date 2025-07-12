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

// State encoding: {mode[1:0], dir}
// dir: 0=left, 1=right
// mode: 2'b00=walk, 2'b01=fall, 2'b10=dig
localparam [2:0]
    WALK_LEFT  = 3'b000,
    WALK_RIGHT = 3'b001,
    FALL_LEFT  = 3'b010,
    FALL_RIGHT = 3'b011,
    DIG_LEFT   = 3'b100,
    DIG_RIGHT  = 3'b101;

reg [2:0] state, next_state;

// Direction update when bumped: 
// If bumped on left or right during walking, update direction:
// new dir = 1 if bump_left else 0 if bump_right else unchanged
// but bump_left and bump_right both 1 means invert direction
wire bump = bump_left | bump_right;
wire bump_both = bump_left & bump_right;

// Extract mode and dir from state
wire [1:0] mode = state[2:1];
wire dir = state[0];

always @(*) begin
    next_state = state; // default hold

    case (mode)
        2'b00: begin // WALK
            if (!ground) begin
                // start falling, same direction
                next_state = {2'b01, dir};
            end else if (dig) begin
                // start digging
                next_state = {2'b10, dir};
            end else if (bump) begin
                // bump changes direction
                if (bump_both)
                    next_state = {2'b00, ~dir};
                else if (bump_left)
                    next_state = {2'b00, 1'b1}; // walk right
                else // bump_right
                    next_state = {2'b00, 1'b0}; // walk left
            end
            // else remain walking same dir
        end
        2'b01: begin // FALL
            if (ground)
                next_state = {2'b00, dir}; // resume walking same dir
        end
        2'b10: begin // DIG
            if (!ground)
                next_state = {2'b01, dir}; // start falling
        end
        default: next_state = state;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

assign walk_left  = (mode == 2'b00) && (dir == 1'b0);
assign walk_right = (mode == 2'b00) && (dir == 1'b1);
assign aaah       = (mode == 2'b01);
assign digging    = (mode == 2'b10);

endmodule