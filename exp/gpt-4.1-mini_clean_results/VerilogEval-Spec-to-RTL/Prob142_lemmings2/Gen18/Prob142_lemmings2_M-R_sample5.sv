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

    // State encoding using named localparams
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state;
    wire falling = state[1];
    wire direction = state[0];

    // Compute next falling bit
    wire next_falling = (falling) ?
                            (ground ? 1'b0 : 1'b1) : // falling->walking if ground reappears, else stay falling
                            (~ground ? 1'b1 : 1'b0); // walking->falling if ground lost, else stay walking

    // Compute next direction bit
    // Bumps only affect direction when walking on ground (falling==0 and ground==1)
    wire bump = bump_left | bump_right;
    wire both_bumps = bump_left & bump_right;

    wire next_direction = (falling) ? direction : // falling: keep direction unchanged
                          (~ground) ? direction : // ground lost this cycle, direction frozen
                          (both_bumps ? ~direction : // both bumps flip direction
                          (bump_left ? 1'b1 :          // bump left -> walk right (1)
                          (bump_right ? 1'b0 :         // bump right -> walk left (0)
                          direction)));                // no bump, keep direction

    wire [1:0] next_state = {next_falling, next_direction};

    // State register with asynchronous reset active high
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs decode from state bits (Moore outputs)
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule