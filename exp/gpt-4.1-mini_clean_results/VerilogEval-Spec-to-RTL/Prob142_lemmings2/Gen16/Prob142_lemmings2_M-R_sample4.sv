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
    // bit1 = falling (1) or walking (0)
    // bit0 = direction: 0 = left, 1 = right
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state;

    wire falling   = state[1];
    wire direction = state[0];

    // Walking next state logic (assumes currently walking)
    wire [1:0] walk_next = (!ground) ? {1'b1, direction} :   // start falling if no ground
                           (bump_left && bump_right) ? {1'b0, ~direction} : // bump both sides: flip direction
                           bump_left ? WALK_RIGHT :                       // bump left: walk right
                           bump_right ? WALK_LEFT :                        // bump right: walk left
                           state;                                         // no change

    // Falling next state logic (assumes currently falling)
    wire [1:0] fall_next = (ground) ? {1'b0, direction} : state; // if grounded, resume walking same direction

    // Next state chosen based on falling or walking
    wire [1:0] next_state = falling ? fall_next : walk_next;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule