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

    // State encoding: bit1 = falling, bit0 = direction
    localparam WALK_LEFT  = 2'b00; // falling=0, direction=0
    localparam WALK_RIGHT = 2'b01; // falling=0, direction=1
    localparam FALL_LEFT  = 2'b10; // falling=1, direction=0
    localparam FALL_RIGHT = 2'b11; // falling=1, direction=1

    reg [1:0] state, next_state;

    // Register bump inputs to reduce glitches and improve timing
    reg bump_left_reg, bump_right_reg;
    wire [1:0] bump_vec = {bump_left_reg, bump_right_reg};

    wire falling   = state[1];
    wire direction = state[0];

    // Register bumps on clock for stable inputs in next-state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bump_left_reg  <= 1'b0;
            bump_right_reg <= 1'b0;
        end else begin
            bump_left_reg  <= bump_left;
            bump_right_reg <= bump_right;
        end
    end

    always @* begin
        if (falling) begin
            // Falling: remain falling until ground returns, ignoring bumps
            if (ground)
                next_state = {1'b0, direction}; // resume walking same direction
            else
                next_state = state;              // keep falling
        end else begin
            // Walking state
            if (!ground) begin
                // Ground disappeared: start falling same direction
                next_state = {1'b1, direction};
            end else begin
                // Walking on ground, update direction based on bumps
                case (bump_vec)
                    2'b11: next_state = {1'b0, ~direction}; // both bumps: flip direction
                    2'b10: next_state = {1'b0, 1'b1};       // bump_left only: walk right
                    2'b01: next_state = {1'b0, 1'b0};       // bump_right only: walk left
                    default: next_state = state;             // no bumps: maintain direction
                endcase
            end
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT; // reset to walking left
        else
            state <= next_state;
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule