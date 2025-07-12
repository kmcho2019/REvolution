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

// Register and synchronize bump inputs to reduce glitches/power
reg bump_left_r, bump_right_r;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        bump_left_r  <= 1'b0;
        bump_right_r <= 1'b0;
    end else begin
        bump_left_r  <= bump_left;
        bump_right_r <= bump_right;
    end
end

// State vector: {dir, mode}
reg [2:0] state;
wire direction = state[2];
wire [1:0] mode = state[1:0];

// Next state logic
reg [2:0] next_state;

always @(*) begin
    next_state = state; // default hold state

    case (mode)
        WLK: begin
            if (!ground) begin
                // ground lost: fall, keep direction
                next_state = {direction, FAL};
            end else if (dig) begin
                // start digging
                next_state = {direction, DIG};
            end else if (bump_left_r || bump_right_r) begin
                // switch walking direction on any bump
                // If both bumped or either bumped, flip direction
                // Use XOR logic to detect bump(s) presence and flip direction
                next_state = {~direction, WLK};
            end
        end
        FAL: begin
            // falling: when ground returns, go back to walking same dir
            if (ground)
                next_state = {direction, WLK};
        end
        DIG: begin
            // digging: if ground lost, start falling
            if (!ground)
                next_state = {direction, FAL};
        end
        default: begin
            next_state = {DIR_LEFT, WLK};
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