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

    // State encoding: bit1 = falling, bit0 = direction (0=left,1=right)
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    // Register bump inputs to reduce glitches and switching power
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

    wire falling   = state[1];
    wire direction = state[0];

    // Combine bump signals into a 2-bit vector to simplify logic
    wire [1:0] bumps = {bump_left_r, bump_right_r};

    always @* begin
        if (falling) begin
            // Falling: hold state until ground returns, ignore bumps
            if (ground)
                next_state = {1'b0, direction}; // resume walking same direction
            else
                next_state = state;
        end else begin
            // Walking state
            if (!ground) begin
                // Ground gone: fall in current direction
                next_state = {1'b1, direction};
            end else begin
                // On ground, adjust direction based on bumps (ignore if none)
                case (bumps)
                    2'b11: next_state = {1'b0, ~direction}; // Both bumps: flip direction
                    2'b10: next_state = {1'b0, 1'b1};        // bump_left only: walk right
                    2'b01: next_state = {1'b0, 1'b0};        // bump_right only: walk left
                    default: next_state = state;              // no bump: maintain direction
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