module TopModule (
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
    localparam [1:0]
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALLING    = 2'd2;

    reg [1:0] state, next_state;
    reg walking_dir; // 0=left, 1=right

    // Synchronize ground for edge detection
    reg ground_d;
    wire ground_falling_edge = (ground_d == 1'b1) && (ground == 1'b0);
    wire ground_rising_edge  = (ground_d == 1'b0) && (ground == 1'b1);

    // Sequential logic: state, walking_dir, and ground_d update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_dir <= 1'b0;  // start walking left
            ground_d <= 1'b1;     // assume ground present on reset
        end else begin
            state <= next_state;
            ground_d <= ground;

            // Update walking_dir only on walking states transitions
            if (next_state == WALK_LEFT)
                walking_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                walking_dir <= 1'b1;
            // else keep walking_dir unchanged (FALLING)
        end
    end

    // Next state combinational logic
    always @(*) begin
        // Default: stay in current state
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (ground_falling_edge) begin
                    // Ground just fell: start falling, ignore bumps
                    next_state = FALLING;
                end else if (ground == 1'b0) begin
                    // Ground already low (falling not caught by edge)
                    next_state = FALLING;
                end else if (ground_rising_edge) begin
                    // Ground just rose, already walking left, no change
                    next_state = WALK_LEFT;
                end else begin
                    // Ground stable high, handle bumps
                    if (bump_left || bump_right) begin
                        next_state = WALK_RIGHT; // switch direction
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
            end

            WALK_RIGHT: begin
                if (ground_falling_edge) begin
                    next_state = FALLING;
                end else if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (ground_rising_edge) begin
                    next_state = WALK_RIGHT;
                end else begin
                    if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end

            FALLING: begin
                if (ground_rising_edge) begin
                    // Ground just rose: resume previous walking direction
                    if (walking_dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else if (ground == 1'b1) begin
                    // Ground stable high during falling, resume walking_dir
                    if (walking_dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    // Still falling
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule