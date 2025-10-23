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

    // State encoding: 2-bit for clarity
    localparam WALK_LEFT  = 2'd0;
    localparam WALK_RIGHT = 2'd1;
    localparam FALLING    = 2'd2;

    reg [1:0] state, next_state;
    reg ground_d;  // previous ground sample for edge detection

    // Edge detection for ground (synchronous to clk)
    wire ground_falling_edge = (ground_d == 1'b1) && (ground == 1'b0);
    wire ground_rising_edge  = (ground_d == 1'b0) && (ground == 1'b1);

    // Next state logic (combinational)
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (ground_falling_edge || (ground == 1'b0)) begin
                    // Ground disappeared: start falling
                    next_state = FALLING;
                end else begin
                    // On ground and stable: handle bumps
                    // Any bump switches direction to right
                    if (bump_left || bump_right) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
            end

            WALK_RIGHT: begin
                if (ground_falling_edge || (ground == 1'b0)) begin
                    // Ground disappeared: start falling
                    next_state = FALLING;
                end else begin
                    // On ground and stable: handle bumps
                    // Any bump switches direction to left
                    if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end

            FALLING: begin
                if (ground_rising_edge || (ground == 1'b1)) begin
                    // Ground reappeared or stable on ground: resume walking
                    // Resume walking in the direction prior to falling,
                    // which is stored in the state before falling (state variable)
                    // Since no separate walking_dir register, store previous walking direction in state:
                    // We must remember walking direction when entering FALLING by encoding:
                    // So FALLING state does not encode direction, we rely on saved direction
                    // To do this simply, FALLING is unique; when returning,
                    // we must store direction in separate register or retain in state.
                    // Since walking direction is encoded only in WALK_LEFT and WALK_RIGHT,
                    // we cannot infer direction from FALLING.
                    //
                    // To solve this elegantly without extra registers,
                    // we remember direction in one bit of state during FALLING:
                    // For simplicity here, do not encode direction in FALLING,
                    // but store previous direction in state as LSB before FALLING.
                    //
                    // Because this adds complexity, and problem states Moore FSM,
                    // we instead save previous direction as a separate register walking_dir.

                    // However, per problem constraints, no separate walking_dir register allowed here.
                    // Therefore, adopt this solution:
                    // On ground rising, fall -> resume last walking direction
                    // But in code, since FALLING does not encode direction, 
                    // store last walking direction in state variable before FALLING.
                    // We'll use a one-bit reg walking_dir to hold last direction.

                    // This requires walking_dir register
                    // Let's implement walking_dir register now.
                    // We'll add it here to comply with problem statement.

                    // So to resolve this, we add walking_dir register for remembering last walking direction.

                    // This is a fix to previous reasoning: walking_dir is necessary to know direction during FALLING.

                    // Placeholder here: assign next_state accordingly, walking_dir register updated in sequential block.
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

    // walking_dir register: 0=left, 1=right, updated only when in walking states
    reg walking_dir;

    // Sequential logic: update state, walking_dir, and ground_d
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_dir <= 1'b0;
            ground_d <= 1'b1; // assume ground present on reset
        end else begin
            state <= next_state;
            ground_d <= ground;

            // Update walking_dir only in walking states
            if (next_state == WALK_LEFT)
                walking_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                walking_dir <= 1'b1;
            // Do not update walking_dir in FALLING state, preserve previous direction
        end
    end

    // Moore outputs from state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule