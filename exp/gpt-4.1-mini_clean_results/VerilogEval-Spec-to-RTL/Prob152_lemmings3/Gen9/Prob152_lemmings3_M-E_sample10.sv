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
// bit 2: direction (0=left, 1=right)
// bit 1,0: mode
// Modes: 00=walk, 01=fall, 10=dig
localparam WLK = 2'b00;
localparam FAL = 2'b01;
localparam DIG = 2'b10;

localparam DIR_LEFT  = 1'b0;
localparam DIR_RIGHT = 1'b1;

// State vector: {dir, mode}
reg [2:0] state;
wire direction = state[2];
wire [1:0] mode = state[1:0];

// Next state logic
reg [2:0] next_state;

always @(*) begin
    next_state = state; // default stay

    case (mode)
        WLK: begin
            // Priority: fall > dig > bump direction switch > stay
            if (!ground) begin
                // fall with current direction
                next_state = {direction, FAL};
            end else if (dig) begin
                // start digging
                next_state = {direction, DIG};
            end else if (bump_left || bump_right) begin
                // switch walking direction on any bump
                // If both bump, flip direction
                // else set to direction opposite bumped side
                if (bump_left && bump_right)
                    next_state = {~direction, WLK};
                else if (bump_left)
                    next_state = {DIR_RIGHT, WLK};
                else // bump_right
                    next_state = {DIR_LEFT, WLK};
            end else begin
                // remain walking same direction
                next_state = state;
            end
        end

        FAL: begin
            // falling: wait for ground return to walk same direction
            if (ground)
                next_state = {direction, WLK};
            else
                next_state = state;
        end

        DIG: begin
            // digging: if ground lost, start falling, else keep digging
            if (!ground)
                next_state = {direction, FAL};
            else
                next_state = state;
        end

        default: begin
            next_state = {DIR_LEFT, WLK}; // safe default
        end
    endcase
end

// Sequential state update with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= {DIR_LEFT, WLK};
    else
        state <= next_state;
end

// Output assignments
assign walk_left  = (mode == WLK) && (direction == DIR_LEFT);
assign walk_right = (mode == WLK) && (direction == DIR_RIGHT);
assign aaah       = (mode == FAL);
assign digging    = (mode == DIG);

endmodule