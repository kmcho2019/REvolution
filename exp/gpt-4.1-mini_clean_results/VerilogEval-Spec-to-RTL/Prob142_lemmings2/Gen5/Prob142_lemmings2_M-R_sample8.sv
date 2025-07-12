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

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state;
    reg [1:0] walk_state_before_fall; // remembers last walking state

    wire bump = bump_left | bump_right;

    // Next state logic
    reg [1:0] next_state;
    reg [1:0] next_walk_state_before_fall;

    always @(*) begin
        next_state = state;
        next_walk_state_before_fall = walk_state_before_fall;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_walk_state_before_fall = WALK_LEFT;
                end else if (bump) begin
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_walk_state_before_fall = WALK_RIGHT;
                end else if (bump) begin
                    next_state = WALK_LEFT;
                end
            end

            FALLING: begin
                if (ground) begin
                    next_state = walk_state_before_fall;
                end
                // else remain falling; bumps ignored
            end

            default: begin
                next_state = WALK_LEFT; // safe default
                next_walk_state_before_fall = WALK_LEFT;
            end
        endcase
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_state_before_fall <= WALK_LEFT;
        end else begin
            state <= next_state;
            walk_state_before_fall <= next_walk_state_before_fall;
        end
    end

    // Outputs: Moore style
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule