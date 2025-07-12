module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding:
    // bit1: falling (1) or walking (0)
    // bit0: direction (0=left, 1=right)
    reg [1:0] state;

    // Determine new direction bit when walking and grounded
    wire new_dir;
    wire walking = ~state[1];
    wire falling =  state[1];

    // When walking on ground, bumps affect direction:
    // bump_left => walk right (1), bump_right => walk left (0)
    // Both bumps => flip direction
    wire bumps_both = bump_left & bump_right;
    wire bumps_left_only = bump_left & ~bump_right;
    wire bumps_right_only = ~bump_left & bump_right;

    wire dir_flipped = ~state[0];
    wire dir_same = state[0];

    assign new_dir = walking && ground ? 
                     (bumps_both ? dir_flipped :
                     (bumps_left_only ? 1'b1 :
                     (bumps_right_only ? 1'b0 :
                     dir_same))) 
                     : state[0];

    // Determine falling bit for next state
    wire next_falling;
    // If walking and ground lost, start falling
    // If falling and ground regained, stop falling
    assign next_falling = walking ? (~ground) : (falling & ~ground);

    // Compose next state
    wire [1:0] next_state = {next_falling, new_dir};

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk left initial state
        else
            state <= next_state;
    end

    // Moore outputs from state
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule